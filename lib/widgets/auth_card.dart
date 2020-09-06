import 'package:flutter/material.dart';

// modos de exibição da tela
enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  // atributo para indicar o modo de autenticação atual
  AuthMode _authMode = AuthMode.Login;
  // controller para a senha
  final _passwordController = TextEditingController();
  // estrutura para armazenar os dados de login
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _submit() {

  }

  @override
  Widget build(BuildContext context) {
    // obtendo o tamanho do dispositivo
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: 320,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              // campo do email
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  // poderia ser externalizado e mais complexo
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Informe um e-mail válido!';
                  }
                  // se não tem erro retorne null
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              // campo da senha
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  // poderia ser externalizado e mais complexo
                  if (value.isEmpty || value.length < 5) {
                    return 'Informe uma senha válida!';
                  }
                  // se não tem erro retorne null
                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
                controller: _passwordController,
              ),
              // segundo campo de confrimação de senha (exibição condicionada)
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar Senha'),
                  obscureText: true,
                  // só valide se estiver em signup (não sei porque precisa)
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          // deve ser igual à senha digitada anteriormente
                          if (value != _passwordController.text) {
                            return 'Senhas são diferentes!';
                          }
                          // se não tem erro retorne null
                          return null;
                        }
                      : null,
                  onSaved: (value) => _authData['password'] = value,
                  controller: _passwordController,
                ),
              // um espaço apenas...
              SizedBox(
                height: 20.0,
              ),
              // botões de ação
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.button.color,
                padding: EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 8.0,
                ),
                child:
                    Text(_authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR'),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
