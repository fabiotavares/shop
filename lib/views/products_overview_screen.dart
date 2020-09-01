import 'package:flutter/material.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/product_grid.dart';
import 'package:provider/provider.dart';

// tela com um GridView para exibir os produtos

enum FilterOption {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    // obtendo acesso ao provider products para saber se deve exibir
    // só os favoritos ou não
    //final Products products = Provider.of(context); // forma global de fazer

    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOption.Favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOption.All,
              ),
            ],
            onSelected: (FilterOption value) {
              // solução de maneira local
              setState(() {
                if (value == FilterOption.Favorite) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });

              // forma global de fazer...
              // if (value == FilterOption.Favorite) {
              //   products.showFavoriteOnly();
              // } else {
              //   products.showAll();
              // }
            },
          ),
        ],
      ),
      body: ProductGrid(_showFavoritesOnly),
    );
  }
}
