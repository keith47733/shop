import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _uid;
  String? _token;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuth {
    if (getToken == null) {
      return false;
    }
    return true;
  }

  String? get getUid {
    if (_token == null) {
      return null;
    }
    if (_expiryDate == null) {
      return null;
    }
    if (_expiryDate!.isBefore(DateTime.now())) {
      return null;
    }
    return _uid;
  }

  String? get getToken {
    if (_token == null) {
      return null;
    }
    if (_expiryDate == null) {
      return null;
    }
    if (_expiryDate!.isBefore(DateTime.now())) {
      return null;
    }
    return _token;
  }

  DateTime? get getExpiryDate {
    if (_token == null) {
      return null;
    }
    if (_expiryDate == null) {
      return null;
    }
    if (_expiryDate!.isBefore(DateTime.now())) {
      return null;
    }
    return _expiryDate;
  }

  String _buildUrlBody(email, password) {
    return json.encode(
      {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      },
    );
  }

  Future<void> signup(email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDwFQzdOV3eeG28swcTykqyu77lsh3x3xo');

    final urlBody = _buildUrlBody(email, password);

    try {
      final response = await http.post(
        url,
        body: urlBody,
      );
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['error'] != null) {
        throw HttpException(decodedResponse['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDwFQzdOV3eeG28swcTykqyu77lsh3x3xo');

    final urlBody = _buildUrlBody(email, password);

    try {
      final response = await http.post(
        url,
        body: urlBody,
      );
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['error'] != null) {
        throw HttpException(decodedResponse['error']['message']);
      }

      _uid = decodedResponse['localId'];
      _token = decodedResponse['idToken'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(decodedResponse['expiresIn'])));
      _resetAutoLogoutTimer();

      final prefs = await SharedPreferences.getInstance();
      final userSessionData = json.encode(
        {
          'user_id': _uid,
          'token': _token,
          'token_expiry_date': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('user_session_data', userSessionData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _uid = null;
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user_session_data')) {
      return false;
    }

    final decodedSessionData = json.decode(prefs.getString('user_session_data')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(decodedSessionData['token_expiry_date']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _uid = decodedSessionData['user_id'];
    _token = decodedSessionData['token'];
    _expiryDate = DateTime.parse(decodedSessionData['token_expiry_date']);
    _resetAutoLogoutTimer();

    return true;
  }

  void _resetAutoLogoutTimer() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final sessionTimeSeconds = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: sessionTimeSeconds), logout);
  }
}
