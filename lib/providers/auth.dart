import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  // Typically, a Firebase token expires after one hour.
  String? _userId;
  String? _authToken;
  DateTime? _authTokenExpiryDate;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    if (_authToken != null && _authTokenExpiryDate != null && _authTokenExpiryDate!.isAfter(DateTime.now())) {
      return _userId;
    }
    return null;
  }

  String? get token {
    if (_authToken != null && _authTokenExpiryDate != null && _authTokenExpiryDate!.isAfter(DateTime.now())) {
      return _authToken;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    // Authentication APIs can be found at https://firebase.google.com/docs/reference/rest/auth#section-create-email-password.
    // https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY] is used to sign up with email and password. This API requires String email, String password, and bool returnSecureToken = true. The API returns, among other things, String idToken, String localid of newly created user. The [API_KEY] should be replaced with Web Api key from our Firebase project (Firebase Overview > Settings > Project Settings > Web API key).
    // Note signup and login will return an error if it can't reach the server, but if it reaches the server it returns a Json regardless of the what happened (ie, doesn't throw an error):
    // {error: {code: 400, message: EMAIL_EXISTS, errors: [{message: EMAIL_EXISTS, domain: global, reason: invalid}]}}

    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDwFQzdOV3eeG28swcTykqyu77lsh3x3xo');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      // If there is no error, set the user auth data and notify the listener (which will rebuild the MaterialApp and set the home screen accordingly).
      _userId = responseData['localId'];
      _authToken = responseData['idToken'];
      _authTokenExpiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      // Technically, _autoLogout() is only required when the user logs in, not when they sign up. But the _authTimer will get overwritten when the user logs in after signing up.
      _resetAutoLogoutTimer();
      notifyListeners();

      // SharedPreferences involves Futures and requires an async code block. SharedPreferences.getInstance(); returns a Future<SharedPreferences>. We await the result and call it prefs. prefs now provides a 'tunnel' to read/write data to device for your app. Can save key, values for various variable types individually or write it as a json.encode() with setString.
      final prefs = await SharedPreferences.getInstance();
      final userSessionData = json.encode({
        'user_id': _userId,
        'token': _authToken,
        'token_expiry_date': _authTokenExpiryDate!.toIso8601String(),
      });
      prefs.setString('user_session_data', userSessionData);
    } catch (error) {
      throw error;
    }
  } // End _authenticate()

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  } // End signUp()

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  } // End login()

  Future<bool> tryAutoLogin() async {
    // This will return true if we find user session data with a valid token (ie, before expiry date), otherwise it will return false and the user will have to log in again.
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user_session_data')) {
      return false;
    }

    // prefs.getString('user_session_data')! is a string, so we need to decode it to a Json map. (We already checked there is a 'user_session_data' key above so we can use !).
    final decodedSessionData = json.decode(prefs.getString('user_session_data')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(decodedSessionData['token_expiry_date']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    // Now we know we have valid data - extract auth data, notify listeners, call _autoLogout to set the timer, and return true (we automatically logged the user in). Login procedure:
    _userId = decodedSessionData['user_id'];
    _authToken = decodedSessionData['token'];
    _authTokenExpiryDate = decodedSessionData['token_expiry_date'];
    _resetAutoLogoutTimer();
    notifyListeners();

    return true;
  }

  Future<void> logout() async {
    _userId = null;
    _authToken = null;
    _authTokenExpiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
		final prefs = await SharedPreferences.getInstance();
		// You can remove individual keys if you are storing a lot of different data in your app. Or you can clear() everything.
		// // prefs.remove('user_session_data');
		prefs.clear();
  } // End logout()

  void _resetAutoLogoutTimer() {
    // Set timer for the duration of token when user logs in, and then call logout() when timer expires. (There are lots of helper methods to work with DateTime objects).
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final sessionTimeSeconds = _authTokenExpiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: sessionTimeSeconds), logout);
  } // End autoLogout()
}
