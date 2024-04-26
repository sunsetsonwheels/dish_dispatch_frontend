import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/root_navigation.dart';
import 'package:dish_dispatch/screens/restaurants/detail.dart';
import 'package:dish_dispatch/screens/restaurants/grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => APIProvider(),
      child: const DishDispatchApp(),
    ),
  );
}

class DishDispatchApp extends StatelessWidget {
  const DishDispatchApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<APIProvider>(context).init(),
      builder: (context, snapshot) {
        return MaterialApp.router(
          title: "Dish Dispatch",
          theme: ThemeData(
            brightness: Brightness.light,
            colorSchemeSeed: Colors.green.shade800,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.green.shade800,
            useMaterial3: true,
          ),
          routeInformationParser: const RoutemasterParser(),
          routerDelegate: RoutemasterDelegate(
            routesBuilder: (context) => RouteMap(
              routes: {
                '/': (route) => const TabPage(
                      child: RootNavigation(),
                      paths: ["/restaurants", "/cart", "/orders"],
                    ),
                '/restaurants': (route) =>
                    const MaterialPage(child: RestaurantsListScreen()),
                '/restaurants/:id': (route) {
                  if (route.pathParameters['id'] == null) {
                    return const Redirect('/restaurants/?noId=1');
                  }
                  return MaterialPage(
                    child: RestaurantDetailScreen(
                      id: route.pathParameters['id']!,
                    ),
                  );
                },
                '/cart': (route) => const MaterialPage(child: Text("Cart")),
                "/orders": (route) => const MaterialPage(child: Text("Orders")),
              },
            ),
          ),
        );
      },
    );
  }
}
