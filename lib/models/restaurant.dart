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
