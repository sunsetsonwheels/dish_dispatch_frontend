import 'package:dish_dispatch/models/customers.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/widgets/customers/cust_membership_card.dart';
import 'package:dish_dispatch/widgets/customers/edit_customer_address_alert.dart';
import 'package:dish_dispatch/widgets/customers/edit_customer_cc_alert.dart';
import 'package:dish_dispatch/widgets/customers/edit_customer_name_alert.dart';
import 'package:dish_dispatch/widgets/customers/edit_customer_phone_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerInfoScreen extends StatelessWidget {
  const CustomerInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<APIProvider>(
      builder: (context, api, _) {
        Customer customer = api.customer!;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Customer info"),
          ),
          body: ListView(
            children: [
              const CustomerMembershipCard(),
              ListTile(
                title: const Text("Phone"),
                subtitle: Text(customer.phone),
                trailing: const Icon(Icons.phone),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const EditCustomerPhoneAlert(),
                  barrierDismissible: false,
                ),
              ),
              ListTile(
                title: const Text("Name"),
                subtitle: Text(customer.name),
                trailing: const Icon(Icons.person),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const EditCustomerNameAlert(),
                  barrierDismissible: false,
                ),
              ),
              ListTile(
                title: const Text("Address"),
                subtitle: Text(customer.address),
                trailing: const Icon(Icons.location_pin),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const EditCustomerAddressAlert(),
                  barrierDismissible: false,
                ),
              ),
              ListTile(
                title: const Text("Credit card"),
                subtitle: Text(customer.creditCard.toString()),
                trailing: const Icon(Icons.credit_card),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const EditCustomerCreditCardAlert(),
                  barrierDismissible: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
