import 'package:cached_network_image/cached_network_image.dart';
import 'package:dish_dispatch/models/cart.dart';
import 'package:dish_dispatch/models/restaurant.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemListTile extends StatelessWidget {
  final BaseRestaurant restaurant;
  final String item;
  final CartItem details;
  final bool readOnly;

  const CartItemListTile({
    super.key,
    required this.restaurant,
    required this.item,
    required this.details,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    String subtotal = (details.quantity * details.price).toStringAsFixed(2);

    List<Widget> actions = [
      IconButton.outlined(
        onPressed: details.quantity > 1
            ? () {
                cartProvider.decrease(restaurant: restaurant, item: item);
              }
            : null,
        icon: const Icon(Icons.remove),
      ),
      IconButton.outlined(
        onPressed: () {
          cartProvider.increase(restaurant: restaurant, item: item);
        },
        icon: const Icon(Icons.add),
      ),
      IconButton.filled(
        onPressed: () {
          cartProvider.deleteMenuItem(restaurant: restaurant, item: item);
        },
        icon: const Icon(Icons.delete),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.red.shade500,
          foregroundColor: Colors.white,
        ),
      ),
    ];

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          Provider.of<APIProvider>(context, listen: false)
              .getRestaurantImageUri(
            restaurant: restaurant.phone,
            filename: "$item.jpg",
          ),
        ),
      ),
      title: Text(
        item,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text("x${details.quantity}, \$$subtotal"),
      trailing: !readOnly
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            )
          : null,
    );
  }
}
