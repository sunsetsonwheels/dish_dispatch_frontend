import 'package:dish_dispatch/models/restaurant.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantMenuListItem extends StatelessWidget {
  final String restaurantId;
  final String name;
  final MenuItem item;

  const RestaurantMenuListItem({
    super.key,
    required this.restaurantId,
    required this.name,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GridTile(
        header: GridTileBar(
          backgroundColor: colorScheme.secondaryContainer,
          title: Text(
            name,
            style: TextStyle(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            "\$${item.price.toStringAsFixed(2)}",
            style: TextStyle(color: colorScheme.onPrimaryContainer),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: colorScheme.secondaryContainer,
          title: Wrap(
            direction: Axis.horizontal,
            children: [
              Text(
                item.description,
                style: TextStyle(color: colorScheme.onSecondaryContainer),
              ),
            ],
          ),
        ),
        child: Image.network(
          Provider.of<APIProvider>(context).getRestaurantImageUri(
              restaurant: restaurantId, filename: "$name.jpg"),
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
