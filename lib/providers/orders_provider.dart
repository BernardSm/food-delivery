import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

enum DeliveryType { pickup, delivery }
enum Status { waiting, processing, completed, cancelled }

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;
  final DeliveryType deliveryType;
  final String address;
  Status status;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.datetime,
      @required this.deliveryType,
      this.address,
      this.status});

  void setStatus(Status s) {
    this.status = s;
  }
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  OrdersProvider(this.authToken, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getOrders() async {
    final url =
        'https://food-delivery-4645c.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedDate = json.decode(response.body) as Map<String, dynamic>;
    if (extractedDate == null) {
      return;
    }
    extractedDate.forEach((orderedId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderedId,
        amount: orderData['amount'],
        address: orderData['address'],
        products: (orderData['product'] as List<dynamic>)
            .map((item) => CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price']))
            .toList(),
        datetime: DateTime.parse(orderData['datetime']),
        deliveryType: DeliveryType.values.firstWhere((element) =>
            element.toString() == 'DeliveryType.' + orderData['deliveryType']),
        status: Status.values.firstWhere(
            (element) => element.toString() == 'Status.' + orderData['status']),
      ));
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    });
  }

  Future<void> addOrder(double total, List<CartItem> cartProducts, type,
      Status s, String address) async {
    final url =
        'https://food-delivery-4645c.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final request = await http.post(url,
        body: json.encode({
          'amount': total,
          'datetime': timestamp.toIso8601String(),
          'product': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
          'address': address,
          'deliveryType':
              type.toString().substring(type.toString().indexOf('.') + 1),
          'status': s.toString().substring(s.toString().indexOf('.') + 1),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(request.body)['name'],
        amount: total,
        address: address,
        products: cartProducts,
        datetime: timestamp,
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

  Future<void> cancelOrder(String id, Status status) async {
    final orderIndex = _orders.indexWhere((ord) => ord.id == id);
    if (orderIndex >= 0) {
      final url =
          'https://food-delivery-4645c.firebaseio.com/orders/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'status':
              status.toString().substring(status.toString().indexOf('.') + 1),
        }),
      );
      notifyListeners();
    }
  }
}
