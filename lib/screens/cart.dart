import 'package:dish_dispatch/providers/cart_provider.dart';
import 'package:dish_dispatch/widgets/cart/item_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          List<Widget> restaurantsTiles = [
            ListTile(
              leading: Text(
                "Total",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Text(
                "\$${cartProvider.total.toStringAsFixed(2)}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ];
          for (final restaurantsItems in cartProvider.cart.entries) {
            List<Widget> cartMenuTiles = [];
            for (final cartMenuItem in restaurantsItems.value.entries) {
              cartMenuTiles.add(
                CartItemListTile(
                  restaurant: restaurantsItems.key,
                  item: cartMenuItem.key,
                  details: cartMenuItem.value,
                ),
              );
            }
            restaurantsTiles.add(
              ExpansionTile(
                title: Text(restaurantsItems.key.name),
                initiallyExpanded: true,
                children: cartMenuTiles,
              ),
            );
          }
          return ListView(
            children: restaurantsTiles,
          );
        },
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return FloatingActionButton.extended(
            onPressed: cartProvider.cart.isNotEmpty
                ? () {
                    Routemaster.of(context).push("/checkout");
                  }
                : null,
            icon: const Icon(Icons.shopping_cart_checkout),
            label: const Text("Checkout"),
          );
        },
      ),
    );
  }
}
