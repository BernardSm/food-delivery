import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart' show OrdersProvider;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/order_screen';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: orderData.orders.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 400,
                  height: 400,
                  child: Image.asset(
                    'assets/images/no orders.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return OrderItem(orderData.orders[index]);
              },
              itemCount: orderData.orders.length,
            ),
    );
  }
}
