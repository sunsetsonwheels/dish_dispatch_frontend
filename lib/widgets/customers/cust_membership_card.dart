import 'package:dish_dispatch/models/customers.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CustomerMembershipCard extends StatefulWidget {
  const CustomerMembershipCard({super.key});

  @override
  State<CustomerMembershipCard> createState() => _CustomerMembershipCardState();
}

class _CustomerMembershipCardState extends State<CustomerMembershipCard> {
  final dateFormat = DateFormat("dd/MM/yyyy");

  Future<void> openSubscribeDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select plan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Monthly"),
                subtitle: const Text("every 30 days"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () async {
                  await Provider.of<APIProvider>(context, listen: false)
                      .setCustomerMembership(
                    plan: CustomerMembershipPlan.monthly,
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Yearly"),
                subtitle: const Text("every 365 days"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () async {
                  await Provider.of<APIProvider>(context, listen: false)
                      .setCustomerMembership(
                    plan: CustomerMembershipPlan.yearly,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> unsubscribe() async {
    await Provider.of<APIProvider>(context, listen: false)
        .setCustomerMembership(plan: null);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<APIProvider>(
      builder: (context, api, _) {
        final Customer customer = api.customer!;
        final ThemeData theme = Theme.of(context);

        List<Widget> children = [
          Text(
            "Dish Dispatch Pro",
            style: theme.textTheme.headlineMedium,
          ),
          if (customer.membership == null)
            Text(
              "Subscribe to earn more discounts & lower service charges.",
              style: theme.textTheme.bodyLarge,
            ),
          if (customer.membership != null)
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: "You're subscribed to the "),
                  TextSpan(
                    text: customer.membership!.plan.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(text: " plan, which renews on "),
                  TextSpan(
                    text: dateFormat.format(customer.membership!.renewDate),
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed:
                customer.membership == null ? openSubscribeDialog : unsubscribe,
            style: customer.membership != null
                ? ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade500,
                    foregroundColor: Colors.white,
                  )
                : null,
            child: customer.membership != null
                ? const Text("Cancel")
                : const Text("Subscribe"),
          ),
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card.filled(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }
}
