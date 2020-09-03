import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  //objetos de controle do foco do campo preço (precisa do dispose no final)
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    // necessário para saber quando perdeu o foco e atualizar a imagem
    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    // liberação de memória
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    // necessário pois um listener foi criado neste caso
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  void _updateImage() {
    // setState vazio:
    // isso pega os valores atuais das variáveis acima e aplica na tela
    setState(() {});
  }

  void _saveForm() {
    // chamada quando o formulário for submetido

    // método save: chama o onSave de cada campo do formulário
    _form.currentState.save();

    // neste ponto eu tenho o map _formData com todos os dados digitados
    // criando o objeto...
    final newProduct = Product(
      id: Random().nextDouble().toString(),
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
    );

    print(newProduct.id);
    print(newProduct.title);
    print(newProduct.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  // executado quando o campo for submetido
                  // passando o focus para o campo de preço
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) => _formData['title'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) {
                  // executado quando o campo for submetido
                  // passando o focus para o campo de preço
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) => _formData['price'] = double.parse(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) => _formData['description'] = value,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    // sem isso dá problema
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'URL da Imagem'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      // preciso aqui para ter acesso ao valor durante o
                      // controle de foco
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) => _formData['imageUrl'] = value,
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 10,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a URL')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
