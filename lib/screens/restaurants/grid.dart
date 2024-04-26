import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:provider/provider.dart';
import 'package:dish_dispatch/widgets/restaurants/grid_item.dart';

class RestaurantsListScreen extends StatefulWidget {
  const RestaurantsListScreen({super.key});

  @override
  State<RestaurantsListScreen> createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends State<RestaurantsListScreen> {
  late APIProvider api;
  Map<String, Restaurant> restaurants = {};
  Set<String> cuisines = {};

  @override
  Widget build(BuildContext context) {
    api = Provider.of<APIProvider>(context);
    bool isVertical = MediaQuery.of(context).size.width < 640;

    SliverAppBar appBar = SliverAppBar.large(
      title: const Text("Restaurants"),
      actions: [
        IconButton(
          onPressed: () => Routemaster.of(context).push("/restaurants/?q="),
          icon: const Icon(Icons.search),
        ),
      ],
    );

    return Scaffold(
      body: FutureBuilder(
        future: api.getRestaurants(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                appBar,
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            );
          }
          List<RestaurantGridItem> items = [];
          snapshot.requireData.forEach((key, value) {
            items.add(RestaurantGridItem(id: key, restaurant: value));
          });
          return CustomScrollView(
            slivers: [
              appBar,
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid.count(
                  crossAxisCount: isVertical ? 1 : 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: items,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
