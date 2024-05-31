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
  late Future<Restaurant> restaurant;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    api = Provider.of<APIProvider>(context, listen: false);
    restaurant = api.getRestaurantDetails(id: widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isVertical = MediaQuery.of(context).size.width < 640;

    return FutureBuilder(
      future: restaurant,
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
        final Restaurant restaurant = snapshot.requireData;
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
                restaurant: restaurant,
                name: key,
                item: value,
              ),
            );
          },
        );
        listChildren.add(Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            controller: controller,
            shrinkWrap: true,
            crossAxisCount: isVertical ? 1 : 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: menuGridChildren,
          ),
        ));
        return Scaffold(
          appBar: AppBar(
            title: Text(restaurant.name),
          ),
          body: ListView(
            controller: controller,
            children: listChildren,
          ),
        );
      },
    );
  }
}
