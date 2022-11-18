import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _userId;
  String? _authToken;
  DateTime? _authTokenExpiryDate;
  Timer? _authTimer;

  bool get isAuth {
    if (getAuthToken == null) {
      return false;
    }
    return true;
  }

  String? get getUserId {
    if (_authToken == null) {
      return null;
    }
    if (_authTokenExpiryDate == null) {
      return null;
    }
    if (_authTokenExpiryDate!.isBefore(DateTime.now())) {
      return null;
    }
    return _userId;
  }

  String? get getAuthToken {
    if (_authToken == null) {
      return null;
    }
    if (_authTokenExpiryDate == null) {
      return null;
    }
    if (_authTokenExpiryDate!.isBefore(DateTime.now())) {
      return null;
    }
    return _authToken;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDwFQzdOV3eeG28swcTykqyu77lsh3x3xo');
    print(url);

    String urlBody = json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    print(urlBody);

    try {
      final response = await http.post(
        url,
        body: urlBody,
        // body: json.encode(
        //   {
        //     'email': email,
        //     'password': password,
        //     'returnSecureToken': true,
        //   },
        // ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      print('TOKEN EXPIRY: ${responseData['expiresIn']}');
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _userId = responseData['localId'];
      print('TO WRITE TO USER PREFS: USER ID: $_userId');
      _authToken = responseData['idToken'];
      _authTokenExpiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _resetAutoLogoutTimer();

      final prefs = await SharedPreferences.getInstance();
      final userSessionData = json.encode({
        'user_id': _userId,
        'token': _authToken,
        'token_expiry_date': _authTokenExpiryDate!.toIso8601String(),
      });
      print(userSessionData);
      prefs.setString('user_session_data', userSessionData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    print('LOGIN EMAIL: $email');
    print('LOGIN EMAIL: $password');
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _userId = null;
    _authToken = null;
    _authTokenExpiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
		print ('LOGOUT: CLEARED USER DATA');
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
		print('LOGOUT: CLEARED SHARED PREFS');
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user_session_data')) {
      return false;
    }
		print('PREFS CONTAIN USER_SESSION_DATA');

    final decodedSessionData = json.decode(prefs.getString('user_session_data')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(decodedSessionData['token_expiry_date']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _userId = decodedSessionData['user_id'];
    _authToken = decodedSessionData['token'];
    _authTokenExpiryDate = decodedSessionData['token_expiry_date'];
    _resetAutoLogoutTimer();
    notifyListeners();
		print('RESUMED SAVED SESSION');

    return true;
  }

  void _resetAutoLogoutTimer() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final sessionTimeSeconds = _authTokenExpiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: sessionTimeSeconds), logout);
  }
}
