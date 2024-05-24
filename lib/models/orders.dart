import 'package:dish_dispatch/models/cart.dart';
import 'package:dish_dispatch/models/customers.dart';
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
class Order {
  final String? id;
  @ISODateTimeConverter()
  DateTime date;
  Map<String, Map<String, CartItem>> cart;
  OrderSummary summary;
  String? notes;
  OrderStatus status;
  Customer customer;
  @JsonKey(name: "used_membership")
  bool usedMembership;
  OrderReview? review;

  Order({
    this.id,
    required this.date,
    required this.cart,
    required this.summary,
    this.notes,
    this.status = OrderStatus.pending,
    required this.customer,
    this.usedMembership = false,
    this.review,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
