import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'customers.g.dart';

@JsonSerializable()
class CustomerCreditCard {
  String number;
  String code;
  String expiry;

  CustomerCreditCard({
    required this.number,
    required this.code,
    required this.expiry,
  });

  factory CustomerCreditCard.fromJson(Map<String, dynamic> json) =>
      _$CustomerCreditCardFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerCreditCardToJson(this);

  @override
  String toString() =>
      "*${number.substring(number.length - 3)}, expires $expiry";
}

@JsonEnum()
enum CustomerMembershipPlan {
  @JsonValue("monthly")
  monthly,
  @JsonValue("yearly")
  yearly;

  @override
  String toString() {
    switch (this) {
      case CustomerMembershipPlan.monthly:
        return "monthly";
      case CustomerMembershipPlan.yearly:
        return "yearly";
    }
  }
}

@JsonSerializable()
class CustomerMembership {
  CustomerMembershipPlan plan;
  @JsonKey(name: "start_date")
  DateTime startDate;
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime get renewDate {
    switch (plan) {
      case CustomerMembershipPlan.monthly:
        return startDate.add(const Duration(days: 30));
      case CustomerMembershipPlan.yearly:
        return startDate.add(const Duration(days: 365));
    }
  }

  CustomerMembership({
    required this.plan,
    required this.startDate,
  });

  factory CustomerMembership.fromJson(Map<String, dynamic> json) =>
      _$CustomerMembershipFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerMembershipToJson(this);
}

@JsonSerializable()
class Customer {
  String phone;
  String name;
  String address;

  @JsonKey(name: "credit_card")
  CustomerCreditCard creditCard;
  CustomerMembership? membership;

  Customer({
    required this.phone,
    required this.name,
    required this.address,
    required this.creditCard,
    this.membership,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

class CustomerAuth {
  final String phone;
  final String password;

  CustomerAuth({
    required this.phone,
    required this.password,
  });

  @override
  String toString() =>
      "Basic ${base64.encode(utf8.encode('$phone:$password'))}";
}
