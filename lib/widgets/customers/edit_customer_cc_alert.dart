import 'package:dish_dispatch/models/customers.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/widgets/utils/cancel_pop_button.dart';
import 'package:dish_dispatch/widgets/utils/error_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCustomerCreditCardAlert extends StatefulWidget {
  const EditCustomerCreditCardAlert({super.key});

  @override
  State<EditCustomerCreditCardAlert> createState() =>
      _EditCustomerCreditCardAlertState();
}

class _EditCustomerCreditCardAlertState
    extends State<EditCustomerCreditCardAlert> {
  final formKey = GlobalKey<FormState>();
  final ccNumberController = TextEditingController();
  final ccCodeController = TextEditingController();
  final ccExpiryController = TextEditingController();
  final textController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    CustomerCreditCard cc =
        Provider.of<APIProvider>(context, listen: false).customer!.creditCard;
    ccNumberController.text = cc.number;
    ccCodeController.text = cc.code;
    ccExpiryController.text = cc.expiry;
  }

  @override
  void dispose() {
    ccNumberController.dispose();
    ccCodeController.dispose();
    ccExpiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit credit card"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: ccNumberController,
                decoration: const InputDecoration(labelText: "Number"),
                validator: (number) {
                  if (number == null || number.isEmpty) {
                    return "Number cannot be empty!";
                  }
                  return null;
                },
                autofocus: true,
              ),
              TextFormField(
                controller: ccCodeController,
                decoration: const InputDecoration(labelText: "Code"),
                validator: (code) {
                  if (code == null || code.isEmpty) {
                    return "Code cannot be empty!";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ccExpiryController,
                decoration: const InputDecoration(labelText: "Expiry"),
                validator: (expiry) {
                  if (expiry == null || expiry.isEmpty) {
                    return "Expiry cannot be empty!";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        CancelPopButton(disabled: isSaving),
        TextButton(
            onPressed: !isSaving
                ? () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        setState(() {
                          isSaving = true;
                        });
                        APIProvider api =
                            Provider.of<APIProvider>(context, listen: false);
                        await api.changeCustomerCreditCard(
                          number: ccNumberController.text,
                          code: ccCodeController.text,
                          expiry: ccExpiryController.text,
                        );
                        Navigator.pop(context);
                      } catch (error) {
                        setState(() {
                          isSaving = false;
                        });
                        showDialog(
                          context: context,
                          builder: (_) => ErrorAlertWidget(error: error),
                        );
                      }
                    }
                  }
                : null,
            child: const Text("Save")),
      ],
    );
  }
}
