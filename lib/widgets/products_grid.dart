import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFavs ? productsData.favItems : productsData.items;

    return products.isEmpty
        ? Center(
            child: Text('You have no favorites.'),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _isLandscape ? 2 : 1,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              // create: (context) => products[index],
              value: products[index],
              child: ProductItem(),
            ),
          );
  }
}
