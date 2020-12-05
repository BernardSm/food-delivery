import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart' as square;

import '../providers/cart.dart'
    show
        CartProvider; //because we have conflicting class names we use this method to only show the portion of the class we are interested in
import '../widgets/cart_item.dart';
import '../providers/orders_provider.dart';

class CartScreen extends StatefulWidget {
  static String routeName = '/cart_screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _expanded = false;
  var _isloading = false;
  DeliveryType checkedValue;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    TextEditingController _addressController = TextEditingController();
    String _address = '';

    Future<void> _payment() async {
      await InAppPayments.setSquareApplicationId(
          'sandbox-sq0idb-QpDqa6aohJOr89x6rKyuEQ');
      await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: (square.CardDetails results) {
          try {
            InAppPayments.completeCardEntry(
                onCardEntryComplete: () => print('yay'));
          } on Exception catch (ex) {
            print('there are problems');
            InAppPayments.showCardNonceProcessingError(ex.toString());
          }
          cart.clear();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.all(50),
              content: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Transform.scale(
                    scale: 2,
                    child: FittedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline_sharp,
                            color: Colors.green,
                            size: 60.0,
                          ),
                          Text(
                            'Your order was placed.',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onCardEntryCancel: () {},
      );
    }

    void makeOrder() async {
      setState(() {
        checkedValue = DeliveryType.pickup;
        _isloading = true;
      });
      Navigator.of(context).pop();

      if (cart.items.isNotEmpty) {
        await Provider.of<OrdersProvider>(context, listen: false).addOrder(
            cart.grandTotal,
            cart.items.values.toList(),
            checkedValue,
            Status.waiting,
            _address);
        setState(() {
          _isloading = false;
        });
        _payment();
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return Container(
                  padding: EdgeInsets.only(right: 8.0),
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Location'),
                          textInputAction: TextInputAction.done,
                          controller: _addressController,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(
                                  context, _addressController.value.text);
                            },
                            child: Text('Done'),
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).then((value) {
            setState(() {
              _address = value;
            });
          });
        },
        icon: Icon(Icons.room_outlined),
        label: Text('Add Location'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                        Spacer(),
                        Text(
                          cart.items.isEmpty
                              ? '\$0.00'
                              : '\$${cart.grandTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        FlatButton(
                          onPressed: (cart.grandTotal <= 0 || _isloading)
                              ? null
                              : () {
                                  //Start of dialog
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text(
                                                'How will you collect your meal?'),
                                            content: Text(
                                                'Please select delivery if you want it delivered or in-store if you are coming in to pick it up.'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('In-store'),
                                                onPressed: () {
                                                  setState(() {
                                                    checkedValue =
                                                        DeliveryType.pickup;
                                                  });
                                                  makeOrder();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Delivery'),
                                                onPressed: () {
                                                  setState(() {
                                                    checkedValue =
                                                        DeliveryType.delivery;
                                                  });
                                                  makeOrder();
                                                },
                                              ),
                                            ],
                                          ));
                                },
                          //End of alert dialog

                          child: _isloading
                              ? CircularProgressIndicator()
                              : Text('Order Now'),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        IconButton(
                          icon: Icon(_expanded
                              ? Icons.expand_less
                              : Icons.expand_more),
                          onPressed: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  if (_expanded)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      height: min(4 * 15.0 + 20, 110),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //Delivery cost indicator
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Sub Total:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              Text(
                                '\$${cart.subTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //Delivery cost indicator
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Delivery Cost:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              Text(
                                cart.items.isEmpty
                                    ? '\$0.00'
                                    : '\$${cart.deliveryCost}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          //GCT cost indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'GCT:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              Text(
                                '\$${cart.gct.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return CartItem(
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                  title: cart.items.values.toList()[index].title,
                  quantity: cart.items.values.toList()[index].quantity,
                  price: cart.items.values.toList()[index].price,
                );
              },
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}
