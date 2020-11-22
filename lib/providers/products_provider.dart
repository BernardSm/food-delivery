import 'package:flutter/material.dart';

import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'z1',
      title: 'Zinger (only)',
      category: 'Zingers',
      description: '1 Zinger with cheese only.',
      price: 585,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2017-09/KFC_eComm_thumb_eComm_ONLY_Zinger.jpg',
    ),
    Product(
      id: 'z2',
      title: 'Zinger Combo',
      category: 'Zingers',
      description: '1 Hot \'n\' Spicy Zinger, 1 Reg. Fries, 1 Pepsi 457mL.',
      price: 720,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2018-01/KFC_eComm_thumb_eComm_Zinger.jpg',
    ),
    Product(
      id: 'z3',
      title: 'BBQ Zinger (only)',
      category: 'Zingers',
      description: '1 BBQ Zinger with cheese only.',
      price: 585,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2017-09/KFC_eComm_thumb_eComm_ONLY_BBQZinger.jpg',
    ),
    Product(
      id: 'z4',
      title: 'BBQ Zinger Combo',
      category: 'Zingers',
      description: '1 Spicy BBQ Zinger, 1 Reg. Fries, 1 Pepsi 457mL.',
      price: 720,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2018-01/KFC_eComm_thumb_eComm_BBQZinger.jpg',
    ),
    Product(
      id: 'z5',
      title: 'Western Zinger (only)',
      category: 'Zingers',
      description: '1 Western Zinger only.',
      price: 650,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2017-09/KFC_eComm_thumb_eComm_ONLY_WesternZinger.jpg',
    ),
    Product(
      id: 'z6',
      title: 'Western Zinger Combo',
      category: 'Zingers',
      description: '1 Hot \'n\' Spicy Zinger with Cheese, Bacon, Onion Rings, & BBQ Sauce, 1 Reg. Fries, 1 Pepsi 457mL.',
      price: 750,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2018-01/KFC_eComm_thumb_eComm_WesternZinger.jpg',
    ),
    Product(
      id: 'v1',
      title: 'Chicken Box Combo',
      category: 'Value',
      description: '1 Pc. Chicken, 1 Reg Fries, 1 Biscuit, 1 Pepsi 457mL.',
      price: 450,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2018-01/KFC_eComm_thumb_eComm_Value.jpg',
    ),
    Product(
      id: 'v2',
      title: 'Popcorn Chicken (SM) Combo',
      category: 'Value',
      description: '1 Sm. Popcorn Chicken, 1 Reg. Fries, 1 Pepsi 457mL. ',
      price: 430,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2018-01/KFC_eComm_thumb_eComm_PopcornChicken.jpg',
    ),
    Product(
      id: 'v3',
      title: 'Famous Bowl',
      category: 'Value',
      description: '1 Famous Bowl, 1 Pepsi 457mL.',
      price: 430,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2018-01/KFC_eComm_thumb_eComm_FamousBowl.jpg',
    ),
    Product(
      id: 's1',
      title: 'Large Fries',
      category: 'Sides',
      description: 'Crisp fresh fries',
      price: 190,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2017-09/Fries.jpg',
    ),
    Product(
      id: 's2',
      title: 'Mashed Potatoes',
      category: 'Sides',
      description: 'Creamy flavored mashed potatoes',
      price: 165,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2017-09/Mashed-Potatoes.jpg',
    ),
    Product(
      id: 's3',
      title: 'Coleslaw',
      category: 'Sides',
      description: 'Fresh vegetables',
      price: 180,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2017-09/coleslaw.jpg',
    ),
    Product(
      id: 's4',
      title: 'Biscuits',
      category: 'Sides',
      description: 'Fresh baked flour',
      price: 70,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2017-09/biscuits.jpg',
    ),
    Product(
      id: 'de1',
      title: 'Cookies',
      category: 'Desserts',
      description: 'Chocolate Chip or Oatmeal',
      price: 100,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2017-09/KFC_eComm_thumb_eComm_Cookie.jpg',
    ),
    Product(
      id: 'de2',
      title: 'Pies',
      category: 'Desserts',
      description: 'Apple, Hershey or Oreo',
      price: 300,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2017-09/KFC_eComm_thumb_eComm_Pie.jpg',
    ),
    Product(
      id: 'dr1',
      title: 'Aqua Water',
      category: 'Drinks',
      description: 'Just the best water',
      price: 100,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2018-05/Aqua%20Water_1.png',
    ),
    Product(
      id: 'dr2',
      title: 'Pepsi',
      category: 'Drinks',
      description: 'Refreshing soda',
      price: 180,
      imageUrl:
          'https://www.kfcjamaica.com/sites/default/files/2018-05/Pepsi_0.png',
    ),
  ];

  var _showFavoriteOnly = false;

  /* Due to dart being a reference type language, the getter is so constructed to avoid giving direct access to the items in memory */
  List<Product> get items {
    // if(_showFavoriteOnly){
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favItems {
    return items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly(){
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll(){
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  void addProduct(Product value) {
    final newProduct = Product(
        title: value.title,
        category: value.category,
        description: value.description,
        price: value.price,
        imageUrl: value.imageUrl,
        id: DateTime.now().toString());
    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct){
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if(prodIndex >= 0){
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String productid){
    _items.removeWhere((prod) => prod.id == productid);
    notifyListeners();
  }
}
