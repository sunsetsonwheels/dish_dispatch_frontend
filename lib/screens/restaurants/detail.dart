import 'package:dish_dispatch/models/restaurant.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/widgets/restaurants/menu_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String id;

  const RestaurantDetailScreen({super.key, required this.id});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  late APIProvider api;

  @override
  Widget build(BuildContext context) {
    api = Provider.of<APIProvider>(context);
    ThemeData theme = Theme.of(context);
    bool isVertical = MediaQuery.of(context).size.width < 640;

    return FutureBuilder(
      future: api.getRestaurantDetails(id: widget.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Loading..."),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final RestaurantDetails restaurant = snapshot.requireData;
        List<Widget> listChildren = [
          ListTile(
            title: const Text("Cuisine"),
            subtitle: Text(restaurant.cuisine),
            trailing: const Icon(Icons.restaurant_menu),
          ),
          ListTile(
            title: const Text("Phone"),
            subtitle: Text(widget.id),
            trailing: const Icon(Icons.phone),
          ),
          ListTile(
            title: const Text("Address"),
            subtitle: Text(restaurant.address),
            trailing: const Icon(Icons.navigation),
          ),
        ];
        List<Widget> menuGridChildren = [];
        restaurant.menu.forEach(
          (key, value) {
            menuGridChildren.add(
              RestaurantMenuListItem(
                restaurantId: widget.id,
                name: key,
                item: value,
              ),
            );
          },
        );
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Text(
                    restaurant.name,
                  ),
                  background: Image.network(
                    api.getRestaurantImageUri(
                      restaurant: widget.id,
                      filename: "hero.jpg",
                    ),
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.4),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Info",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverList.list(children: listChildren),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Menu",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                sliver: SliverGrid.count(
                  crossAxisCount: isVertical ? 1 : 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: menuGridChildren,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
