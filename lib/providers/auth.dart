import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  // api do firebase para autenticação. Link:
  // https://firebase.google.com/docs/reference/rest/auth?hl=pt_br
  static const _url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBMbEoU5DKTwrq2zw3IggV1Re6LzJv-_Ss';

  Future<void> signup(String email, String password) async {
    final response = await http.post(
      _url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    print(json.decode(response.body));

    return Future.value();
  }
}
