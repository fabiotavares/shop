import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/utils/constants.dart';

class Products with ChangeNotifier {
  //---------------
  final _baseUrl = '${Constants.BASE_API_URL}/products';
  List<Product> _items = [];
  String _token;
  String _userId;

  Products([this._token, this._userId, this._items = const []]);

  //---------------

  // esse get retorna uma cópia da lista (através do operador
  // spread), para evitar acesso direto ao seu conteúdo
  List<Product> get items => [..._items];

  //---------------

  int get itemsCount {
    return _items.length;
  }

  //---------------

  // lista de favoritos somente
  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  //---------------

  // obtendo a lista de produtos do servidor
  Future<void> loadProducts() async {
    // requisição dos produtos no servidor
    final response = await http.get('$_baseUrl.json?auth=$_token');
    Map<String, dynamic> data = json.decode(response.body);
    // requisição para os favoritos deste usuário
    final favResponse = await http.get(
        '${Constants.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token');
    final favMap =
        favResponse.body != null ? json.decode(favResponse.body) : null;

    if (data != null) {
      // limpar lista
      _items.clear();

      // pegar dados atualizados
      data.forEach((productId, productData) {
        // descobrindo se é favorito deste usuário
        // ?? é um teste adicional permitindo um valor padrão (uau)
        final isFavorite = favMap == null ? false : favMap[productId] ?? false;
        _items.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ));
      });
      // atualizar exibição dos dados
      notifyListeners();
    }
    // também funciona sem esse return
    return Future.value();
  }

  //---------------

  Future<void> addProduct(Product newProduct) async {
    // trabalhando com requisições http
    // vou retornar um Future da forma abaixo, para fechar o formulário apenas
    // quando a requisição tiver sido completada no servidor
    final response = await http.post(
      // await faz aguardar a execução do bloco
      // response tem a chave da inserção do produto
      '$_baseUrl.json?auth=$_token',
      body: json.encode({
        'title': newProduct.title,
        'price': newProduct.price,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
      }),
    );
    //código executado só depois de cadastrado no servidor web
    // adiciona um novo produto igual ao passado e com a geração do id aqui
    _items.add(Product(
      // a resposta do firebase traz um corpo com a chave criada lá (name)
      id: json.decode(response.body)['name'],
      title: newProduct.title,
      description: newProduct.description,
      price: newProduct.price,
      imageUrl: newProduct.imageUrl,
    ));
    // houve uma alteração na lista que precisa ser notificada
    // usando um método da classe mixins ChangeNotifier
    notifyListeners();
  }

  //---------------

  Future<bool> updateProduct(Product product) async {
    // o produto e seu id precisam ser diferentes de nulos para prosseguir
    if (product == null || product.id == null) {
      return Future.value(false);
    }

    // tenta localizar o produto na lista de produtos
    final index = _items.indexWhere((element) => element.id == product.id);

    // se o index == -1 significa que não encontrou o produto
    if (index == -1) {
      return Future.value(false);
    }

    // caso contrário, posso executar a atualização
    await http.patch(
      '$_baseUrl/${product.id}.json?auth=$_token',
      body: json.encode({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite,
      }),
    );

    // atualiza a lista local apenas no item modificado
    _items[index] = product;
    notifyListeners();

    return Future.value(true);
  }

  //---------------

  Future<void> removeItem(String productId) async {
    // tenta localizar o produto na lista de produtos
    final index = _items.indexWhere((element) => element.id == productId);

    // se o index == -1 significa que não encontrou o produto
    if (index == -1) {
      return;
    }

    // obtem o objeto que deve ser removido
    final product = _items[index];

    // remove o produto da lista primeiramente
    _items.remove(product);
    notifyListeners();

    // Tente atualizar o servidor
    final response =
        await http.delete('$_baseUrl/${product.id}.json?auth=$_token');

    // se houve erro no servidor (percebido da forma abaixo)...
    if (response.statusCode >= 400) {
      // devo retornar com a exibição do produto removido da lista
      _items.insert(index, product);
      notifyListeners();
      // lançar excessão para ser tratado onde chamou
      throw HttpException('Ocorreu um erro na exclusão do produto!');
    }

    // outra forma de fazer mais direta
    // _items.removeWhere((element) => element.id == productId);
  }
}
