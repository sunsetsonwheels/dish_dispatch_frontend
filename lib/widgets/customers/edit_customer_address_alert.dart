import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/widgets/utils/cancel_pop_button.dart';
import 'package:dish_dispatch/widgets/utils/error_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCustomerAddressAlert extends StatefulWidget {
  const EditCustomerAddressAlert({super.key});

  @override
  State<EditCustomerAddressAlert> createState() =>
      _EditCustomerAddressAlertState();
}

class _EditCustomerAddressAlertState extends State<EditCustomerAddressAlert> {
  final textController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    textController.text =
        Provider.of<APIProvider>(context, listen: false).customer!.address;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit address"),
      content: TextField(
        controller: textController,
        readOnly: isSaving,
        keyboardType: TextInputType.streetAddress,
        maxLines: 2,
        autofocus: true,
      ),
      actions: [
        CancelPopButton(disabled: isSaving),
        TextButton(
            onPressed: !isSaving
                ? () async {
                    try {
                      setState(() {
                        isSaving = true;
                      });
                      if (textController.text.isEmpty) {
                        throw Exception("Input cannot be empty!");
                      }
                      APIProvider api =
                          Provider.of<APIProvider>(context, listen: false);
                      api.changeCustomerAddress(textController.text);
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
                : null,
            child: const Text("Save")),
      ],
    );
  }
}
