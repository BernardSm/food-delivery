import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyy hh:mm').format(widget.order.datetime),
            ),
            leading: Column(
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
                        child: FlatButton(
                          onPressed: () async {
                            try {
                              await Provider.of<ord.OrdersProvider>(context,
                                      listen: false)
                                  .cancelOrder(
                                      widget.order.id, ord.Status.cancelled);

                              setState(() {
                                widget.order.setStatus(ord.Status.cancelled);
                              });
                              _expanded = !_expanded;
                            } catch (error) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Could not cancel order.'),
                              ));
                            }
                          },
                          child: Text('Cancel'),
                          textColor: Colors.white,
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
