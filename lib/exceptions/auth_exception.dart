class AuthException implements Exception {
  // tipos de erros apontados na documentação do Firebase
  // https://firebase.google.com/docs/reference/rest/auth?hl=pt_br
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já existe!',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Tente mais tarde!',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado!',
    'INVALID_PASSWORD': 'Senha inválida!',
    'USER_DISABLED': 'Usuário desativado!',
  };
  final String key;

  AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    }
    // mensagem genérica
    return "Ocorreu um erro na autenticação!";
  }
}
