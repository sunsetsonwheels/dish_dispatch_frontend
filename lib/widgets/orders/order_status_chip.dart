import 'package:dish_dispatch/models/orders.dart';
import 'package:flutter/material.dart';

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color? color;
    switch (status) {
      case OrderStatus.pending:
        color = Colors.grey;
        break;
      case OrderStatus.rejected:
        color = Colors.red;
        break;
      case OrderStatus.preparing:
        color = Colors.yellow;
        break;
      case OrderStatus.shipping:
        color = Colors.amber;
        break;
      case OrderStatus.completed:
        color = Colors.green;
        break;
    }
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color,
      ),
      label: Text(status.name),
    );
  }
}
