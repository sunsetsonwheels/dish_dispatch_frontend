// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSummary _$OrderSummaryFromJson(Map<String, dynamic> json) => OrderSummary(
      subtotal: (json['subtotal'] as num).toDouble(),
      surcharge: (json['surcharge'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderSummaryToJson(OrderSummary instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'surcharge': instance.surcharge,
    };

OrderReview _$OrderReviewFromJson(Map<String, dynamic> json) => OrderReview(
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$OrderReviewToJson(OrderReview instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'comment': instance.comment,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as String?,
      date: const ISODateTimeConverter().fromJson(json['date'] as String),
      cart: (json['cart'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as Map<String, dynamic>).map(
              (k, e) =>
                  MapEntry(k, CartItem.fromJson(e as Map<String, dynamic>)),
            )),
      ),
      summary: OrderSummary.fromJson(json['summary'] as Map<String, dynamic>),
      notes: json['notes'] as String?,
      status: $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
          OrderStatus.pending,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      usedMembership: json['used_membership'] as bool? ?? false,
      review: json['review'] == null
          ? null
          : OrderReview.fromJson(json['review'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'date': const ISODateTimeConverter().toJson(instance.date),
      'cart': instance.cart,
      'summary': instance.summary,
      'notes': instance.notes,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'customer': instance.customer,
      'used_membership': instance.usedMembership,
      'review': instance.review,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.rejected: 'rejected',
  OrderStatus.preparing: 'preparing',
  OrderStatus.shipping: 'shipping',
  OrderStatus.completed: 'completed',
};
