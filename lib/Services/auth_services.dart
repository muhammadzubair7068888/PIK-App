import 'dart:convert';

import 'package:http/http.dart' as http;

import 'globals.dart';

class AuthServices {
  static Future<http.Response> signUp(
    String username,
    String email,
    String password,
    String passwordConfirmation,
    bool termsAndConditions,
  ) async {
    Map data = {
      "username": username,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "terms_and_conditions": termsAndConditions,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> login(String email, String password) async {
    Map data = {
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }
}
