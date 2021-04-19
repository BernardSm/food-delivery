import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart' as ord;
import '../providers/auth.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context).userId;

    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyy hh:mm').format(widget.order.datetime),
            ),
            leading: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                        width: 20,
                        height: 20,
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //If order is waiting to be accepted
                      if (widget.order.status == ord.Status.waiting)
                        Icon(
                          Icons.hourglass_top,
                          color: Colors.yellow,
                        ),

                      //If order is accepted
                      if (widget.order.status == ord.Status.processing)
                        Icon(
                          Icons.delivery_dining,
                          color: Colors.indigo,
                        ),

                      //If order is completed
                      if (widget.order.status == ord.Status.completed)
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                        ),

                      //If order is cancelled
                      if (widget.order.status == ord.Status.cancelled)
                        Icon(
                          Icons.block,
                          color: Colors.red,
                        ),
                    ],
                  ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    height: min(widget.order.products.length * 20.0 + 20, 110),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(
                                widget.order.products[index].title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            Text(
                              '${widget.order.products[index].quantity}x  \$${widget.order.products[index].price}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        );
                      },
                      itemCount: widget.order.products.length,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: widget.order.status == ord.Status.cancelled
                            ? Container()
                            : TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('About to cancel order'),
                                      content: Text(
                                          'Are you sure you want to cancel your order?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('No'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Yes'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            try {
                                              Provider.of<ord.OrdersProvider>(
                                                      context,
                                                      listen: false)
                                                  .cancelOrder(
                                                    userId!,
                                                    widget.order.id,
                                                    ord.Status.cancelled,
                                                  )
                                                  .then((value) => {
                                                        setState(() {
                                                          widget.order
                                                              .setStatus(ord
                                                                  .Status
                                                                  .cancelled);
                                                          _isLoading = false;
                                                        })
                                                      });

                                              _expanded = !_expanded;
                                            } catch (error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Could not cancel order.'),
                                              ));
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text('Cancel'),
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red),
                                    textStyle:
                                        MaterialStateProperty.all<TextStyle>(
                                            TextStyle(color: Colors.white)),
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    )),
                              ),
                      ),
                    ],
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
