import 'package:dish_dispatch/models/customers.dart';
import 'package:dish_dispatch/models/orders.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final notesController = TextEditingController();
  late Customer customer;
  late OrderRequest order;
  bool isCheckingOut = false;

  @override
  void initState() {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    customer = Provider.of<APIProvider>(context, listen: false).customer!;
    order = OrderRequest(
      cart: cartProvider.getRequestCart(),
      summary: OrderSummary(
        subtotal: cartProvider.total,
        surcharge: 0.03,
      ),
      deliveryInfo: OrderDeliveryInfo(
        phone: customer.phone,
        name: customer.name,
        address: customer.address,
      ),
      usedMembership: false,
    );

    super.initState();
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  Future<void> checkout() async {
    setState(() {
      isCheckingOut = true;
    });
    if (notesController.text.isNotEmpty) {
      order.notes = notesController.text;
    }
    await Provider.of<APIProvider>(context, listen: false).submitCustomerOrder(
      order: order,
    );
    Provider.of<CartProvider>(context, listen: false).clear();
    Routemaster.of(context).replace("/orders");
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? titleMedium = Theme.of(context).textTheme.titleMedium;

    List<Widget> listChildren = [
      ListTile(
        leading: Text(
          "Delivery contact",
          style: titleMedium,
        ),
      ),
      ListTile(
        title: const Text("Phone"),
        subtitle: Text(order.deliveryInfo.phone),
        trailing: const Icon(Icons.phone),
      ),
      ListTile(
        title: const Text("Name"),
        subtitle: Text(order.deliveryInfo.name),
        trailing: const Icon(Icons.person),
      ),
      ListTile(
        title: const Text("Address"),
        subtitle: Text(order.deliveryInfo.address),
        trailing: const Icon(Icons.location_pin),
      ),
      ListTile(
        leading: Text(
          "Payment method",
          style: titleMedium,
        ),
      ),
      RadioListTile(
        toggleable: customer.membership != null,
        value: true,
        groupValue: order.usedMembership,
        onChanged: !isCheckingOut && customer.membership != null
            ? (_) {
                setState(() {
                  order.usedMembership = true;
                  order.summary.surcharge = 0.015;
                });
              }
            : null,
        secondary: const Icon(Icons.add),
        title: const Text("Dish Dispatch Pro"),
        subtitle: Text(customer.membership == null
            ? "Subscribe to Dish Dispatch Pro to access benefits."
            : "Pay with & use your membership benefits for this order."),
      ),
      RadioListTile(
        toggleable: !isCheckingOut,
        value: false,
        groupValue: order.usedMembership,
        onChanged: !isCheckingOut
            ? (_) {
                setState(() {
                  order.usedMembership = false;
                  order.summary.surcharge = 0.03;
                });
              }
            : null,
        secondary: const Icon(Icons.credit_card),
        title: const Text("Credit card"),
        subtitle: Text(
            "Use credit card on file (${customer.creditCard.toString()}). Higher costs."),
      ),
      ListTile(
        leading: Text(
          "Additional notes",
          style: titleMedium,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            isDense: true,
            hintText: "Allergies, special requests, etc.",
          ),
        ),
      ),
      ListTile(
        leading: Text(
          "Order summary",
          style: titleMedium,
        ),
      ),
      ListTile(
        title: const Text("Subtotal"),
        trailing: Text(
          "\$${order.summary.subtotal.toStringAsFixed(2)}",
          style: titleMedium?.copyWith(fontStyle: FontStyle.italic),
        ),
      ),
      ListTile(
        title: const Text("Surcharge"),
        subtitle: Text(order.usedMembership
            ? "Fixed 1.5% surcharge for members"
            : "3% (card processing & service fees)"),
        trailing: Text(
          "\$${(order.summary.subtotalSurcharge).toStringAsFixed(2)}",
          style: titleMedium?.copyWith(fontStyle: FontStyle.italic),
        ),
      ),
      ListTile(
        title: const Text("Total"),
        trailing: Text(
          "\$${order.summary.total.toStringAsFixed(2)}",
          style: titleMedium,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: FilledButton(
          onPressed: !isCheckingOut ? checkout : null,
          child: isCheckingOut
              ? const CircularProgressIndicator()
              : const Text("Checkout"),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        automaticallyImplyLeading: !isCheckingOut,
      ),
      body: ListView(
        children: listChildren,
      ),
    );
  }
}
