import 'package:dish_dispatch/models/restaurant.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/widgets/restaurants/grid_item.dart';
import 'package:dish_dispatch/widgets/utils/error_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class RestaurantsListScreen extends StatefulWidget {
  final String? cuisine;
  final String? name;

  const RestaurantsListScreen({super.key, this.cuisine, this.name});

  @override
  State<RestaurantsListScreen> createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends State<RestaurantsListScreen> {
  final searchController = TextEditingController();
  late Future<RestaurantResponse> response;

  void setResponse() {
    response = Provider.of<APIProvider>(context, listen: false).getRestaurants(
      cuisine: widget.cuisine,
      name: !(widget.name?.isEmpty ?? true) ? widget.name : null,
    );
  }

  @override
  void initState() {
    super.initState();
    setResponse();
  }

  @override
  void didUpdateWidget(covariant RestaurantsListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cuisine != oldWidget.cuisine ||
        (widget.name != oldWidget.name)) {
      setResponse();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isVertical = MediaQuery.of(context).size.width < 640;
    Routemaster router = Routemaster.of(context);

    return FutureBuilder<RestaurantResponse>(
      future: response,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Restaurants"),
            ),
            body: snapshot.hasError
                ? ErrorPlaceholderWidget(error: snapshot.error!)
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        }
        RestaurantResponse data = snapshot.requireData;

        List<RestaurantGridItem> items = [];
        for (final restaurant in data.restaurants) {
          items.add(RestaurantGridItem(restaurant: restaurant));
        }
        List<Widget> cuisineChips = [
          const SizedBox(
            width: 16,
          ),
          FilterChip(
            showCheckmark: false,
            label: const Text("All"),
            selected: widget.cuisine == null,
            onSelected: (_) => router.push("/restaurants"),
          ),
        ];
        for (final cuisine in data.cuisines) {
          cuisineChips.add(const SizedBox(
            width: 6,
          ));
          cuisineChips.add(
            FilterChip(
              showCheckmark: false,
              label: Text(cuisine),
              selected: widget.cuisine == cuisine,
              onSelected: (_) => setState(() {
                router.push(
                  "/restaurants",
                  queryParameters: {"cuisine": cuisine},
                );
              }),
            ),
          );
        }
        cuisineChips.add(const SizedBox(
          width: 16,
        ));

        return Scaffold(
          appBar: AppBar(
            title: widget.name != null
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: "Search for a restaurant...",
                      ),
                      onSubmitted: (value) {
                        if (value.isEmpty) {
                          router.push("/restaurants");
                        } else {
                          router.push("/restaurants?name=$value");
                        }
                      },
                    ),
                  )
                : const Text("Restaurants"),
            bottom: widget.name == null
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: cuisineChips,
                        ),
                      ),
                    ),
                  )
                : null,
            actions: widget.name == null
                ? [
                    IconButton(
                      onPressed: () => router.push("/restaurants/?name="),
                      icon: const Icon(Icons.search),
                    ),
                  ]
                : null,
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: GridView.count(
              crossAxisCount: isVertical ? 1 : 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: items,
            ),
          ),
        );
      },
    );
  }
}
