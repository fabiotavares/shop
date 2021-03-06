import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // necessário para saber quando perdeu o foco e atualizar a imagem
    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // verificar se um produto foi passado para edição
    final product = ModalRoute.of(context).settings.arguments as Product;

    // se houver um produto para edição, deve-se atualizar o map com seus dados
    // apenas na primeira vez, ou seja, quando _formData for vazio
    if (_formData.isEmpty) {
      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;
        // o controle precisa ser inicializado aqui para refletir no formulário
        _imageUrlController.text = _formData['imageUrl'];
      } else {
        // garantir que não aparece null em valor quando for cadastrar novo produto
        _formData['price'] = '';
      }
    }
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
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.Jpeg');
    return (startWithHttp || startWithHttps) &&
        (endsWithPng || endsWithJpg || endsWithJpeg);
  }

  Future<void> _saveForm() async {
    // chamada quando o formulário for submetido

    // método validate: chma o validator de cada campo do formulário
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      // se não passou pela validação, não continue
      return;
    }

    // método save: chama o onSave de cada campo do formulário
    // vai inserir todos os valores digitados dentro de um map
    _form.currentState.save();

    // neste ponto eu tenho o map _formData com todos os dados digitados
    // criando o objeto a partir do map criando antes
    final product = Product(
      // o id só existirá caso um produto tenha sido passado para edição
      id: _formData['id'],
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
    );

    // iniciando indicativo de processamento
    setState(() {
      _isLoading = true;
    });

    // acessando o provider de produtos para adicionar o novo produto
    // IMPORTANTE: preciso passar listen: false pra funcionar
    // isso pois estou fora do build (fora da árvore de widgets)
    // RESUMINDO: posso usar o Provider fora do build, DESDE que não use listen
    final products = Provider.of<Products>(context, listen: false);

    try {
      // tenta adicionar novo produto ou editar existente
      if (_formData['id'] == null) {
        await products.addProduct(product);
      } else {
        await products.updateProduct(product);
      }
      // fehca a tela de formulário após operação realizada com sucesso
      Navigator.of(context).pop();
    } catch (_) {
      // exibe mensagem de erro para o usuário
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Ocorreu um erro ao salvar o produto!'),
          actions: [
            FlatButton(
              // só fecha a tela do alerta
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      // pare o indicador de progresso e permanece na tela para nova tentativa
      setState(() {
        _isLoading = false;
      });
    } 
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                // autovalidate: true, // é uma possibilidade
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['title'],
                      decoration: InputDecoration(labelText: 'Título'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        // executado quando o campo for submetido
                        // passando o focus para o campo de preço
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        // é chamada quando a validação do formulário for disparada
                        // retorna uma string
                        // se retornar null significa que não há erro (foi validado)
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = value.trim().length < 3;

                        if (isEmpty || isInvalid) {
                          return 'Informe um título válido com no mínimo 3 caracteres!';
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['title'] = value,
                    ),
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      decoration: InputDecoration(labelText: 'Preço'),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onFieldSubmitted: (_) {
                        // executado quando o campo for submetido
                        // passando o focus para o campo de preço
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value),
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        var newPrice = double.tryParse(value);
                        bool isInvalid = newPrice == null || newPrice <= 0;

                        if (isEmpty || isInvalid) {
                          return 'Informe um preço válido!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      decoration: InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) => _formData['description'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = value.trim().length < 10;

                        if (isEmpty || isInvalid) {
                          return 'Informe uma descrição válida com no mínimo 10 caracteres!';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          // sem isso dá problema
                          child: TextFormField(
                            // não posso usar aqui o initialValue pois estou usando
                            // controller. Neste caso, preciso inicializar por ele.
                            // initialValue: _formData['imageUrl'],
                            decoration:
                                InputDecoration(labelText: 'URL da Imagem'),
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
                            validator: (value) {
                              bool isEmpty = value.trim().isEmpty;
                              bool isInvalid = !isValidImageUrl(value);

                              if (isEmpty || isInvalid) {
                                return 'Informe uma URL válida!';
                              }
                              return null;
                            },
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
                              : Image.network(_imageUrlController.text),
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
