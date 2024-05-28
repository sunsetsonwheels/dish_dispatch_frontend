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
  late Future<List<OrderResponse>> ordersFuture;

  void newFuture() {
    setState(() {
      ordersFuture =
          Provider.of<APIProvider>(context, listen: false).getCustomerOrders();
    });
  }

  @override
  void initState() {
    newFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Routemaster router = Routemaster.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        actions: [
          IconButton(
            onPressed: newFuture,
            icon: const Icon(Icons.refresh),
          ),
          IconButton.filledTonal(
            onPressed: () => router.push("/customer"),
            icon: const Icon(Icons.person_2),
          )
        ],
      ),
      body: FutureBuilder(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final orders = snapshot.requireData;
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
