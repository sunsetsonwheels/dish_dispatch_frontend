class Restaurant {
  final String name;
  final String address;
  final String cuisine;

  Restaurant({
    required this.name,
    required this.address,
    required this.cuisine,
  });

  Restaurant.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        address = json['address'] as String,
        cuisine = json['cuisine'] as String;
}

class MenuItem {
  final String description;
  final double price;

  MenuItem({
    required this.description,
    required this.price,
  });

  MenuItem.fromJson(Map<String, dynamic> json)
      : description = json['description'] as String,
        price = json['price'] as double;
}

class RestaurantDetails extends Restaurant {
  final Map<String, MenuItem> menu;

  RestaurantDetails({
    required super.name,
    required super.address,
    required super.cuisine,
    required this.menu,
  });

  RestaurantDetails.fromJson(Map<String, dynamic> json)
      : menu = (json["menu"] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, MenuItem.fromJson(v))),
        super.fromJson(json);
}
