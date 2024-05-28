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

OrderDeliveryInfo _$OrderDeliveryInfoFromJson(Map<String, dynamic> json) =>
    OrderDeliveryInfo(
      phone: json['phone'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$OrderDeliveryInfoToJson(OrderDeliveryInfo instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'name': instance.name,
      'address': instance.address,
    };

OrderRestaurant _$OrderRestaurantFromJson(Map<String, dynamic> json) =>
    OrderRestaurant(
      phone: json['phone'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$OrderRestaurantToJson(OrderRestaurant instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'name': instance.name,
    };

OrderInOrder _$OrderInOrderFromJson(Map<String, dynamic> json) => OrderInOrder(
      id: json['id'] as String,
      restaurant:
          OrderRestaurant.fromJson(json['restaurant'] as Map<String, dynamic>),
      items: (json['items'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, CartItem.fromJson(e as Map<String, dynamic>)),
      ),
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      review: json['review'] == null
          ? null
          : OrderReview.fromJson(json['review'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderInOrderToJson(OrderInOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant': instance.restaurant,
      'items': instance.items,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'review': instance.review,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.rejected: 'rejected',
  OrderStatus.preparing: 'preparing',
  OrderStatus.shipping: 'shipping',
  OrderStatus.completed: 'completed',
};

Map<String, dynamic> _$OrderRequestToJson(OrderRequest instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'notes': instance.notes,
      'delivery_info': instance.deliveryInfo,
      'used_membership': instance.usedMembership,
      'cart': instance.cart,
    };

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      summary: OrderSummary.fromJson(json['summary'] as Map<String, dynamic>),
      notes: json['notes'] as String?,
      deliveryInfo: OrderDeliveryInfo.fromJson(
          json['delivery_info'] as Map<String, dynamic>),
      usedMembership: json['used_membership'] as bool,
      id: json['id'] as String,
      date: const ISODateTimeConverter().fromJson(json['date'] as String),
      customerPhone: json['customer_phone'] as String,
      relatedOrders: (json['related_orders'] as List<dynamic>)
          .map((e) => OrderInOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
