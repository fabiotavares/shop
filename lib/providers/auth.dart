import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  // controle do token
  String _token;
  String _userId;
  DateTime _expiryDate;

  // indica se está autenticado
  bool get isAuth {
    return token != null;
  }

  // identificação do usuário autenticado (para os favoritos e pedidos)
  String get userId {
    return isAuth ? _userId : null;
  }

  // indica se há um token válido
  String get token {
    // se o token existe e ainda não expirou, retorne seu valor
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      // caso contrário, retorne null para exigir novo login
      return null;
    }
  }

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

    // verificando se houve algum tipo de erro
    final responseBody = json.decode(response.body);
    if (responseBody['error'] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      // obtendo a data de expiração
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseBody['expiresIn']),
      ));

      notifyListeners();
    }

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
