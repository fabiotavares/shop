import 'package:flutter/material.dart';

// forma local de alterar a animação na transição entre as telas
class CustomRoute<T> extends MaterialPageRoute<T> {
  // classe criada para alterar a animação na transição entre as páginas

  // construtor (copiado parcialmente da classe super)
  CustomRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  // sobrescrever o método que me interessa neste caso
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == '/') {
      //sem animação se for a tela home
      return child;
    }

    // com animação caso seja outra
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// forma global de alterar a animação na transição entre as telas
class CustomPageTransitionsBuilder<T> extends PageTransitionsBuilder {
  // classe criada para alterar a animação na transição entre as páginas

  // sobrescrever o método que me interessa neste caso
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // animação para todas as rotas
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
