import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/providers/auth.dart';

// modos de exibição da tela
enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  // atributo para ter acesso ao formulário
  GlobalKey<FormState> _form = GlobalKey();
  // atributo usado p/ controlar a exibição dos botões em caso de processamento
  bool _isLoading = false;
  // atributo para indicar o modo de autenticação atual
  AuthMode _authMode = AuthMode.Login;
  // controller para a senha
  final _passwordController = TextEditingController();

  // animações
  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // inicializado as variáveis para a animação na mudança de tamanho do card
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      // tipo de animação
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0.0, 0.0),
    ).animate(
      // tipo de animação
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  // estrutura para armazenar os dados de login
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> _submit() async {
    // se não conseguiu validar, encerra processamento
    if (!_form.currentState.validate()) {
      return;
    }

    // indica início do processamento
    setState(() {
      _isLoading = true;
    });

    // Chamando onSave dos campos do formulário
    _form.currentState.save();

    // aqui já tenho o _authData preenchido e posso processar
    Auth auth = Provider.of<Auth>(context, listen: false);

    // tente fazer login ou registrar novo usuário
    try {
      if (_authMode == AuthMode.Login) {
        // lógica para o login
        await auth.login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // lógica para o registro
        await auth.signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on AuthException catch (e) {
      _showErrorDialog(e.toString());
    } catch (e) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    // atualizando tela
    setState(() => _isLoading = false);
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um erro'),
        content: Text(msg),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Fechar'),
          )
        ],
      ),
    );
  }

  void _switchMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      // animação pra frente (crescendo)
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      // animação pra trás (diminiundo)
      _controller.reverse();
    }
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        height: _authMode == AuthMode.Login ? 290 : 371,
        // height: _heighAnimation.value.height,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        // parte passada pelo child acima
        child: cardForm(context),
      ),
    );
  }

  Form cardForm(BuildContext context) {
    return Form(
      key: _form,
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
          AnimatedContainer(
            constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.Signup ? 60 : 0,
              maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
            ),
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: TextFormField(
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
                ),
              ),
            ),
          ),
          // um espaço apenas...
          Spacer(),
          if (_isLoading)
            CircularProgressIndicator()
          else
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
              child: Text(_authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR'),
              onPressed: _submit,
            ),
          FlatButton(
            onPressed: _switchMode,
            child: Text(
              "ALTERNAR P/ ${_authMode == AuthMode.Login ? 'REGISTRAR' : 'LOGIN'}",
            ),
            textColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
