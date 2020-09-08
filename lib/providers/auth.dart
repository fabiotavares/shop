import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  // controle do token
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _logoutTimer;

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

      // salvar dados do usuário logado
      Store.saveMap(
        'userData',
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );

      // ativa o timer para auto logout
      _autoLogout();
      notifyListeners();
    }

    return Future.value();
  }

  //
  Future<void> signup(String email, String password) async {
    // fazer signUp (inscrição)
    return _authenticate(email, password, "signUp");
  }

  //
  Future<void> login(String email, String password) async {
    // fazer login
    return _authenticate(email, password, "signInWithPassword");
  }

  //
  Future<void> tryAutoLogin() async {
    // se já estiver logado, não é necessária nenhuma ação
    if (isAuth) {
      return Future.value();
    }

    // tente identificar o usuário
    final userData = await Store.getMap('userData');
    if (userData == null) {
      return Future.value();
    }

    // verifique se a data é válida
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return Future.value();
    }

    _userId = userData['userId'];
    _token = userData['token'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  //
  void logout() {
    // fazer logout
    _token = null;
    _userId = null;
    _expiryDate = null;
    // cancele o timer do logout se existir
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }
    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    // logout automático
    if (_logoutTimer != null) {
      // se já estiver contanto, o tempo deve ser renovado
      _logoutTimer.cancel();
    }
    // calcular o tempo correto de validade da sessão
    final timeToLogout = _expiryDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout), logout);
  }
}
