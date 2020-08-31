import 'package:flutter/widgets.dart';

// exemplo de como usar um widget herdado para passar informação através
// da árvore de contextos, facilitando o acesso a informações globais

// neste caso ainda precisa usar stateful e setstate para atualizar a tela
// apenas permite o compartilhamento global

// uma classe de exemplo que representa nosso estado a ser comaprtilhado
class CounterState {
  int _value = 1;

  void inc() => _value++;
  void dec() => _value--;
  int get value => _value;

  bool diff(CounterState old) {
    return old == null || old.value != _value;
  }
}

// classe herdada que faz o trabalho por baixo dos panos
// pra funcionar, é preciso envolver o MaterialApp com este CoubterProvider
class CounterProvider extends InheritedWidget {
  // estado
  final CounterState state = CounterState();
  // construtor chamando o construtor pai
  CounterProvider({Widget child}) : super(child: child);

  // método estático of
  static CounterProvider of(BuildContext context) {
    // retorna o objeto que envolve o widget do aplicaitvo
    // retorna nulo se não exisitir
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
