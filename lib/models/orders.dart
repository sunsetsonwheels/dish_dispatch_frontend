import 'package:dish_dispatch/models/cart.dart';
import 'package:dish_dispatch/models/customers.dart';
import 'package:dish_dispatch/models/restaurant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'orders.g.dart';

@JsonSerializable()
class OrderSummary {
  final double subtotal;
  double surcharge;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get subtotalSurcharge => subtotal * surcharge;
  @JsonKey(includeFromJson: false, includeToJson: false)
  double get total => subtotal + surcharge;

  OrderSummary({
    required this.subtotal,
    required this.surcharge,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) =>
      _$OrderSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$OrderSummaryToJson(this);
}

@JsonEnum()
enum OrderStatus {
  @JsonValue("pending")
  pending,
  @JsonValue("rejected")
  rejected,
  @JsonValue("preparing")
  preparing,
  @JsonValue("shipping")
  shipping,
  @JsonValue("completed")
  completed
}

@JsonSerializable()
class OrderReview {
  double rating;
  String comment;

  OrderReview({
    required this.rating,
    required this.comment,
  });

  factory OrderReview.fromJson(Map<String, dynamic> json) =>
      _$OrderReviewFromJson(json);

  Map<String, dynamic> toJson() => _$OrderReviewToJson(this);
}

@JsonSerializable()
class OrderDeliveryInfo {
  String phone;
  String name;
  String address;

  OrderDeliveryInfo({
    required this.phone,
    required this.name,
    required this.address,
  });

  factory OrderDeliveryInfo.fromCustomer(Customer customer) {
    return OrderDeliveryInfo(
      phone: customer.phone,
      name: customer.name,
      address: customer.address,
    );
  }

  factory OrderDeliveryInfo.fromJson(Map<String, dynamic> json) =>
      _$OrderDeliveryInfoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDeliveryInfoToJson(this);
}

class ISODateTimeConverter implements JsonConverter<DateTime, String> {
  const ISODateTimeConverter();

  @override
  DateTime fromJson(String iso) {
    return DateTime.parse(iso);
  }

  @override
  String toJson(DateTime date) => date.toIso8601String();
}

@JsonSerializable()
class BaseOrder {
  OrderSummary summary;
  String? notes;
  @JsonKey(name: "delivery_info")
  OrderDeliveryInfo deliveryInfo;
  @JsonKey(name: "used_membership")
  bool usedMembership;

  BaseOrder({
    required this.summary,
    required this.notes,
    required this.deliveryInfo,
    required this.usedMembership,
  });

  factory BaseOrder.fromJson(Map<String, dynamic> json) =>
      _$BaseOrderFromJson(json);
}

@JsonSerializable()
class OrderRestaurant {
  final String phone;
  final String name;

  const OrderRestaurant({
    required this.phone,
    required this.name,
  });

  factory OrderRestaurant.fromJson(Map<String, dynamic> json) =>
      _$OrderRestaurantFromJson(json);

  factory OrderRestaurant.fromBaseRestaurant(BaseRestaurant restaurant) {
    return OrderRestaurant(
      phone: restaurant.phone,
      name: restaurant.name,
    );
  }

  Map<String, dynamic> toJson() => _$OrderRestaurantToJson(this);
}

@JsonSerializable(createFactory: false)
class OrderRequest extends BaseOrder {
  @JsonKey(name: "customer_phone")
  String customerPhone;
  Map<String, Map<String, CartItem>> cart;

  OrderRequest({
    required super.summary,
    super.notes,
    required super.deliveryInfo,
    required super.usedMembership,
    required this.customerPhone,
    this.cart = const {},
  });

  Map<String, dynamic> toJson() => _$OrderRequestToJson(this);
}

@JsonSerializable()
class OrderResponse extends BaseOrder {
  final String id;
  @ISODateTimeConverter()
  DateTime date;
  @JsonKey(name: "customer_phone")
  String customerPhone;
  @JsonKey(name: "related_orders")
  List<OrderInOrder>? relatedOrders;

  OrderResponse({
    required super.summary,
    super.notes,
    required super.deliveryInfo,
    required super.usedMembership,
    required this.id,
    required this.date,
    required this.customerPhone,
    required this.relatedOrders,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);

  Map<BaseRestaurant, OrderInOrder> toDetailsMap() {
    return {
      for (final order in relatedOrders!)
        BaseRestaurant.fromOrderRestaurant(order.restaurant): order
    };
  }
}

@JsonSerializable()
class BaseOrderInOrder {
  final String id;
  final double total;
  OrderStatus status;
  OrderReview? review;
  @ISODateTimeConverter()
  final DateTime date;

  BaseOrderInOrder({
    required this.id,
    required this.total,
    required this.status,
    this.review,
    required this.date,
  });

  factory BaseOrderInOrder.fromJson(Map<String, dynamic> json) =>
      _$BaseOrderInOrderFromJson(json);
}

@JsonSerializable()
class OrderInOrder extends BaseOrderInOrder {
  final OrderResponse? parent;
  final OrderRestaurant restaurant;
  Map<String, CartItem> items;

  OrderInOrder({
    required super.id,
    this.parent,
    required this.restaurant,
    required super.total,
    required this.items,
    required super.status,
    super.review,
    required super.date,
  });

  factory OrderInOrder.fromJson(Map<String, dynamic> json) =>
      _$OrderInOrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderInOrderToJson(this);
}
