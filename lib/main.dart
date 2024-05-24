import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/providers/cart_provider.dart';
import 'package:dish_dispatch/root_navigation.dart';
import 'package:dish_dispatch/screens/cart.dart';
import 'package:dish_dispatch/screens/checkout.dart';
import 'package:dish_dispatch/screens/customer.dart';
import 'package:dish_dispatch/screens/login.dart';
import 'package:dish_dispatch/screens/orders/details.dart';
import 'package:dish_dispatch/screens/orders/list.dart';
import 'package:dish_dispatch/screens/restaurants/detail.dart';
import 'package:dish_dispatch/screens/restaurants/grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => APIProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
    ],
    child: const DishDispatchApp(),
  ));
}

class DishDispatchApp extends StatefulWidget {
  const DishDispatchApp({super.key});

  @override
  State<DishDispatchApp> createState() => _DishDispatchAppState();
}

class _DishDispatchAppState extends State<DishDispatchApp> {
  final routeInformationParser = const RoutemasterParser();
  final routerDelegate = RoutemasterDelegate(
    routesBuilder: (context) {
      APIProvider api = Provider.of<APIProvider>(context, listen: false);

      return RouteMap(
        routes: {
          '/': (route) => api.isLoggedIn
              ? const TabPage(
                  child: RootNavigation(),
                  paths: ["/restaurants", "/cart", "/orders"],
                )
              : const Redirect("/login"),
          '/restaurants': (route) => MaterialPage(
                child: RestaurantsListScreen(
                  cuisine: route.queryParameters['cuisine'],
                  name: route.queryParameters['name'],
                ),
              ),
          '/restaurants/:id': (route) {
            if (route.pathParameters['id'] == null) {
              return const Redirect('/restaurants');
            }
            return MaterialPage(
              child: RestaurantDetailScreen(
                id: route.pathParameters['id']!,
              ),
            );
          },
          '/cart': (route) => const MaterialPage(child: CartScreen()),
          '/checkout': (route) => const MaterialPage(child: CheckoutScreen()),
          "/orders": (route) => const MaterialPage(child: OrdersListScreen()),
          '/orders/:id': (route) {
            String? id = route.pathParameters['id'];
            if (id == null) {
              return const Redirect('/orders');
            }
            return MaterialPage(child: OrderDetailsScreen(id: id));
          },
          '/customer': (route) =>
              const MaterialPage(child: CustomerInfoScreen()),
          '/login': (route) => const MaterialPage(child: LoginScreen()),
        },
      );
    },
  );
  final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: Colors.green.shade800,
    useMaterial3: true,
  );
  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.green.shade800,
    useMaterial3: true,
  );

  late Future<void> providerInit;

  @override
  void initState() {
    super.initState();
    providerInit = Provider.of<APIProvider>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: providerInit,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            title: "Loading...",
            theme: lightTheme,
            darkTheme: darkTheme,
            builder: (context, child) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return MaterialApp.router(
          title: "Dish Dispatch",
          theme: lightTheme,
          darkTheme: darkTheme,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
        );
      },
    );
  }
}
