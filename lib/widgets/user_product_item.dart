import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products_provider.dart';
import '../screens/product_detail_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: id),
        child: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('About to delete item'),
                          content: Text(
                              'Are you sure you want to delete this product?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('Remove'),
                              onPressed: () async {
                                try {
                                  await Provider.of<ProductsProvider>(
                                    context,
                                    listen: false,
                                  ).deleteProduct(id);
                                  Navigator.of(context).pop();
                                } catch (error) {
                                  scaffold.showSnackBar(SnackBar(
                                    content: Text('Deleting failed!'),
                                  ));
                                }
                              },
                            ),
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
