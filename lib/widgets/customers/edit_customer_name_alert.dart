import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/widgets/utils/cancel_pop_button.dart';
import 'package:dish_dispatch/widgets/utils/error_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCustomerNameAlert extends StatefulWidget {
  const EditCustomerNameAlert({super.key});

  @override
  State<EditCustomerNameAlert> createState() => _EditCustomerNameAlertState();
}

class _EditCustomerNameAlertState extends State<EditCustomerNameAlert> {
  final textController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    textController.text =
        Provider.of<APIProvider>(context, listen: false).customer!.name;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit name"),
      content: TextField(
        controller: textController,
        readOnly: isSaving,
        keyboardType: TextInputType.name,
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
                      api.changeCustomerName(textController.text);
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
