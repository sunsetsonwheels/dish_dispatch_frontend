// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerCreditCard _$CustomerCreditCardFromJson(Map<String, dynamic> json) =>
    CustomerCreditCard(
      number: json['number'] as String,
      code: json['code'] as String,
      expiry: json['expiry'] as String,
    );

Map<String, dynamic> _$CustomerCreditCardToJson(CustomerCreditCard instance) =>
    <String, dynamic>{
      'number': instance.number,
      'code': instance.code,
      'expiry': instance.expiry,
    };

CustomerMembership _$CustomerMembershipFromJson(Map<String, dynamic> json) =>
    CustomerMembership(
      plan: $enumDecode(_$CustomerMembershipPlanEnumMap, json['plan']),
      startDate: DateTime.parse(json['start_date'] as String),
    );

Map<String, dynamic> _$CustomerMembershipToJson(CustomerMembership instance) =>
    <String, dynamic>{
      'plan': _$CustomerMembershipPlanEnumMap[instance.plan]!,
      'start_date': instance.startDate.toIso8601String(),
    };

const _$CustomerMembershipPlanEnumMap = {
  CustomerMembershipPlan.monthly: 'monthly',
  CustomerMembershipPlan.yearly: 'yearly',
};

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      phone: json['phone'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      creditCard: CustomerCreditCard.fromJson(
          json['credit_card'] as Map<String, dynamic>),
      membership: json['membership'] == null
          ? null
          : CustomerMembership.fromJson(
              json['membership'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'phone': instance.phone,
      'name': instance.name,
      'address': instance.address,
      'credit_card': instance.creditCard,
      'membership': instance.membership,
    };
