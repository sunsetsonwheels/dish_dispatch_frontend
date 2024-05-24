// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseRestaurant _$BaseRestaurantFromJson(Map<String, dynamic> json) =>
    BaseRestaurant(
      phone: json['phone'] as String,
      name: json['name'] as String,
      cuisine: json['cuisine'] as String,
    );

Map<String, dynamic> _$BaseRestaurantToJson(BaseRestaurant instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'name': instance.name,
      'cuisine': instance.cuisine,
    };

RestaurantResponse _$RestaurantResponseFromJson(Map<String, dynamic> json) =>
    RestaurantResponse(
      restaurants: (json['restaurants'] as List<dynamic>)
          .map((e) => BaseRestaurant.fromJson(e as Map<String, dynamic>))
          .toList(),
      cuisines:
          (json['cuisines'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$RestaurantResponseToJson(RestaurantResponse instance) =>
    <String, dynamic>{
      'restaurants': instance.restaurants,
      'cuisines': instance.cuisines,
    };

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => MenuItem(
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
      'description': instance.description,
      'price': instance.price,
    };

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      phone: json['phone'] as String,
      name: json['name'] as String,
      cuisine: json['cuisine'] as String,
      address: json['address'] as String,
      menu: (json['menu'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, MenuItem.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'name': instance.name,
      'cuisine': instance.cuisine,
      'address': instance.address,
      'menu': instance.menu,
    };
