import 'package:dish_dispatch/models/orders.dart';
import 'package:dish_dispatch/widgets/orders/order_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class OrderListTile extends StatelessWidget {
  final Order order;
  final DateFormat fmt = DateFormat("dd/MM/yyyy hh:mm");

  OrderListTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(fmt.format(order.date.toLocal())),
      subtitle: Text("\$${order.summary.total.toStringAsFixed(2)}"),
      trailing: OrderStatusChip(
        status: order.status,
      ),
      onTap: () => Routemaster.of(context).push("/orders/${order.id}"),
    );
  }
}
