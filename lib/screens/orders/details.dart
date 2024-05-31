import 'dart:async';

import 'package:dish_dispatch/models/orders.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/widgets/cart/item_list_tile.dart';
import 'package:dish_dispatch/widgets/orders/order_status_chip.dart';
import 'package:dish_dispatch/widgets/orders/review_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String id;

  const OrderDetailsScreen({super.key, required this.id});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Timer refresher;
  late APIProvider api;
  late Future<OrderResponse> orderFuture;

  @override
  void initState() {
    api = Provider.of<APIProvider>(context, listen: false);
    orderFuture = api.getCustomerOrder(id: widget.id);
    refresher = Timer.periodic(const Duration(seconds: 10), (t) {
      setState(() {
        orderFuture = api.getCustomerOrder(id: widget.id);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    refresher.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: orderFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final order = snapshot.requireData;
        TextStyle? titleMedium = Theme.of(context).textTheme.titleMedium;
        List<Widget> listChildren = [
          ListTile(
            leading: Text(
              "Delivery contact",
              style: titleMedium,
            ),
          ),
          ListTile(
            title: const Text("Phone"),
            subtitle: Text(order.deliveryInfo.phone),
            trailing: const Icon(Icons.phone),
          ),
          ListTile(
            title: const Text("Name"),
            subtitle: Text(order.deliveryInfo.name),
            trailing: const Icon(Icons.person),
          ),
          ListTile(
            title: const Text("Address"),
            subtitle: Text(order.deliveryInfo.address),
            trailing: const Icon(Icons.location_pin),
          ),
          ListTile(
            leading: Text(
              "Ordered items",
              style: titleMedium,
            ),
          ),
        ];
        final orderItems = order.toDetailsMap();
        for (final restaurantOrders in orderItems.entries) {
          List<Widget> itemChildren = [];
          for (final item in restaurantOrders.value.items.entries) {
            itemChildren.add(
              CartItemListTile(
                restaurant: restaurantOrders.key,
                item: item.key,
                details: item.value,
                readOnly: true,
              ),
            );
          }
          listChildren.add(
            ExpansionTile(
              leading: IconButton.outlined(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => OrderReviewAlert(
                      parentId: order.id,
                      id: restaurantOrders.value.id,
                      previousReview: restaurantOrders.value.review,
                    ),
                  );
                },
                icon: const Icon(Icons.rate_review),
              ),
              trailing: OrderStatusChip(status: restaurantOrders.value.status),
              title: Text(restaurantOrders.key.name),
              initiallyExpanded: true,
              children: itemChildren,
            ),
          );
        }
        listChildren.addAll([
          ListTile(
            leading: Text(
              "Order summary",
              style: titleMedium,
            ),
          ),
          ListTile(
            title: const Text("Subtotal"),
            trailing: Text(
              "\$${order.summary.subtotal.toStringAsFixed(2)}",
              style: titleMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          ListTile(
            title: const Text("Surcharge"),
            subtitle: Text(order.usedMembership
                ? "Fixed 1.5% surcharge for members"
                : "3% (card processing & service fees)"),
            trailing: Text(
              "\$${(order.summary.subtotalSurcharge).toStringAsFixed(2)}",
              style: titleMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          ListTile(
            title: const Text("Total"),
            trailing: Text(
              "\$${order.summary.total.toStringAsFixed(2)}",
              style: titleMedium,
            ),
          ),
          ListTile(
            title: const Text("Paid via"),
            trailing: Text(
              order.usedMembership ? "Used membership" : "Credit card",
              style: titleMedium,
            ),
          ),
        ]);
        return Scaffold(
          appBar: AppBar(
            title: const Text("Order details"),
          ),
          body: ListView(
            children: listChildren,
          ),
        );
      },
    );
  }
}
