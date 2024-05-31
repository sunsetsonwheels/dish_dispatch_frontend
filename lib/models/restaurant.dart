import 'package:dish_dispatch/models/orders.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class BaseRestaurant {
  final String phone;
  final String name;
  final String cuisine;

  BaseRestaurant({
    required this.phone,
    required this.name,
    required this.cuisine,
  });

  factory BaseRestaurant.fromJson(Map<String, dynamic> json) =>
      _$BaseRestaurantFromJson(json);

  factory BaseRestaurant.fromOrderRestaurant(OrderRestaurant restaurant) =>
      BaseRestaurant(
        phone: restaurant.phone,
        name: restaurant.name,
        cuisine: "",
      );
}

@JsonSerializable()
class RestaurantResponse {
  final List<BaseRestaurant> restaurants;
  final List<String> cuisines;

  RestaurantResponse({
    required this.restaurants,
    required this.cuisines,
  });

  factory RestaurantResponse.fromJson(Map<String, dynamic> json) =>
      _$RestaurantResponseFromJson(json);
}

@JsonSerializable()
class MenuItem {
  final String description;
  final double price;

  MenuItem({
    required this.description,
    required this.price,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
}

@JsonSerializable()
class Restaurant extends BaseRestaurant {
  final String address;
  final Map<String, MenuItem> menu;

  Restaurant({
    required super.phone,
    required super.name,
    required super.cuisine,
    required this.address,
    required this.menu,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
}

@JsonSerializable(createToJson: false)
class RestaurantRating {
  final double average;
  final List<String> recent;

  const RestaurantRating({required this.average, required this.recent});

  factory RestaurantRating.fromJson(Map<String, dynamic> json) =>
      _$RestaurantRatingFromJson(json);
}

@JsonSerializable(createToJson: false)
class RestaurantRevenue {
  final double total;

  const RestaurantRevenue({required this.total});

  factory RestaurantRevenue.fromJson(Map<String, dynamic> json) =>
      _$RestaurantRevenueFromJson(json);
}
