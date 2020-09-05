import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/product_grid.dart';

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
  bool _isLoading = true;
  bool _showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();

    // uma forma de fazer => exige StatefulWidget
    // em order_screen foi usada uma outra técnica com FutureBuilder (melhor)
    Provider.of<Products>(context, listen: false).loadProducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
            },
          ),
          Consumer<Cart>(
            // código que não vai mudar
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
            ),
            builder: (_, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(_showFavoritesOnly, updateGridIsShowFavoriteOnly),
      drawer: AppDrawer(),
    );
  }

  void updateGridIsShowFavoriteOnly() {
    // atualiza caso esteja mostrando apenas favoritos
    if (_showFavoritesOnly) {
      setState(() {});
    }
  }
}
