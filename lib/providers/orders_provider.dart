import 'package:flutter/foundation.dart';

import './cart.dart';

enum DeliveryType { pickup, delivery }
enum Status { waiting, processing, completed, cancelled }

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;
  final DeliveryType deliveryType;
  Status status;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.datetime,
      @required this.deliveryType,
      this.status});

  void setStatus(Status s) {
    this.status = s;
  }
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(double total, List<CartItem> cartProducts, type, Status s) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        datetime: DateTime.now(),
        deliveryType: type,
        status: s,
      ),
    );
    notifyListeners();
  }

  void removeOrder() {
    _orders.removeLast();
    notifyListeners();
  }

  // void cancelOrder(OrderItem item) {
  //   _orders[_orders.indexOf(item)].setStatus(Status.cancelled);
  // }
}
