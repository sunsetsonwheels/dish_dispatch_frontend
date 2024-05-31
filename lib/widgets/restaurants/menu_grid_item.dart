import 'package:dish_dispatch/models/restaurant.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/widgets/restaurants/add_to_cart_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RestaurantMenuListItem extends StatelessWidget {
  final BaseRestaurant restaurant;
  final String name;
  final MenuItem item;

  const RestaurantMenuListItem({
    super.key,
    required this.restaurant,
    required this.name,
    required this.item,
  });

  void showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => AddToCartSheet(
        restaurant: restaurant,
        name: name,
        item: item,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    APIProvider api = Provider.of<APIProvider>(context, listen: false);

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
                maxLines: 2,
                style: TextStyle(color: colorScheme.onSecondaryContainer),
              ),
            ],
          ),
          trailing: IconButton.filledTonal(
            onPressed: () => showAddSheet(context),
            icon: const Icon(Icons.add_shopping_cart),
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: api.getRestaurantImageUri(
            restaurant: restaurant.phone,
            filename: "$name.jpg",
          ),
          fit: BoxFit.cover,
          errorWidget: (context, url, error) {
            return ErrorWidget(error);
          },
        ),
      ),
    );
  }
}
