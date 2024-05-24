import 'package:dish_dispatch/models/orders.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/widgets/orders/order_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:provider/provider.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  @override
  Widget build(BuildContext context) {
    APIProvider api = Provider.of<APIProvider>(context, listen: false);
    Routemaster router = Routemaster.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        actions: [
          IconButton(
            onPressed: () => router.push("/customer"),
            icon: const Icon(Icons.person_2),
          )
        ],
      ),
      body: FutureBuilder<List<Order>>(
        future: api.getCustomerOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Order> orders = snapshot.requireData;

          return ListView.builder(
            itemBuilder: (context, i) {
              return OrderListTile(order: orders[i]);
            },
            itemCount: orders.length,
          );
        },
      ),
    );
  }
}
