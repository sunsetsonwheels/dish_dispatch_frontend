import 'package:dish_dispatch/models/restaurant.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class RestaurantGridItem extends StatelessWidget {
  final String id;
  final Restaurant restaurant;

  const RestaurantGridItem({
    super.key,
    required this.id,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Routemaster.of(context).push("/restaurants/$id"),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: colorScheme.secondaryContainer,
            title: Text(
              restaurant.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            subtitle: Text(
              restaurant.cuisine,
              style: TextStyle(
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
          child: Image.network(
            Provider.of<APIProvider>(context).getRestaurantImageUri(
              restaurant: id,
              filename: "hero.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
