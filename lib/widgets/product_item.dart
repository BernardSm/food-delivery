import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';

import '../widgets/badge.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatefulWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem({
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // });

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<CartProvider>(context);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: GridTile(
          /* Menu item image */
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/menu placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,

            /* Favorite button */
            leading: IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                product.toggleFavoriteStatus(
                  authData.token!,
                  authData.userId!,
                );
              },
              color: Theme.of(context).accentColor,
            ),
            trailing: IconButton(
              /* Display the quantity of this item that has been added to cart*/
              icon: cart.items.containsKey(product.id)
                  ? Badge(
                      child: Icon(Icons.shopping_cart),
                      value: cart.items[product.id]!.quantity.toString(),
                      color: Colors.white,
                    )
                  : Icon(Icons.shopping_cart),

              /* Adding an item to the cart */
              onPressed: () {
                setState(() {
                  cart.addItem(product.id, product.price, product.title);
                });
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${product.title} added to cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () => cart.removeSingleItem(product.id)),
                ));
              },
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              /* Menu item title*/
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
