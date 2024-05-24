import 'dart:async';

import 'package:dish_dispatch/models/orders.dart';
import 'package:dish_dispatch/models/restaurant.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/widgets/cart/item_list_tile.dart';
import 'package:dish_dispatch/widgets/orders/order_status_chip.dart';
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
  late Future<Order> orderFuture;

  @override
  void initState() {
    api = Provider.of<APIProvider>(context, listen: false);
    `orderFuture = api.getCustomerOrder(id: widget.id);`
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
        Order order = snapshot.requireData!;
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
            subtitle: Text(order.customer.phone),
            trailing: const Icon(Icons.phone),
          ),
          ListTile(
            title: const Text("Name"),
            subtitle: Text(order.customer.name),
            trailing: const Icon(Icons.person),
          ),
          ListTile(
            title: const Text("Address"),
            subtitle: Text(order.customer.address),
            trailing: const Icon(Icons.location_pin),
          ),
          ListTile(
            leading: Text(
              "Ordered items",
              style: titleMedium,
            ),
          ),
        ];
        for (final restaurantStringEntry in order.cart.entries) {
          List<String> restaurantString = restaurantStringEntry.key.split(";");
          BaseRestaurant restaurant = BaseRestaurant(
            phone: restaurantString[0],
            name: restaurantString[1],
            cuisine: "",
          );
          List<Widget> itemChildren = [];
          for (final itemEntry in restaurantStringEntry.value.entries) {
            itemChildren.add(
              CartItemListTile(
                restaurant: restaurant,
                item: itemEntry.key,
                details: itemEntry.value,
                readOnly: true,
              ),
            );
          }
          listChildren.add(
            ExpansionTile(
              title: Text(restaurant.name),
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
            actions: [OrderStatusChip(status: order.status)],
          ),
          body: ListView(
            children: listChildren,
          ),
        );
      },
    );
  }
}
