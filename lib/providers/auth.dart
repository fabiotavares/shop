import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  // api do firebase para autenticação. Link:
  // https://firebase.google.com/docs/reference/rest/auth?hl=pt_br

  // método responsável por fazer a autenticação no servidor
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    // url já ajustada com o terceiro parâmetro
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBMbEoU5DKTwrq2zw3IggV1Re6LzJv-_Ss';

    // requisição post conforme descrito na documentação do firebase
    final response = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    print(json.decode(response.body));

    return Future.value();
  }

  Future<void> signup(String email, String password) async {
    // fazer signUp (inscrição)
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    // fazer login
    return _authenticate(email, password, "signInWithPassword");
  }
}
