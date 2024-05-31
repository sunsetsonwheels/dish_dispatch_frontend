import 'package:dish_dispatch/widgets/utils/api_root_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dish_dispatch/providers/api_provider.dart';

class ErrorAlertWidget extends StatelessWidget {
  final Object error;

  const ErrorAlertWidget({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Oops"),
      content: () {
        if (error is APIRequestError) {
          APIRequestError apiRequestError = error as APIRequestError;
          return Text("${apiRequestError.detail} (${apiRequestError.code})");
        } else {
          return Text(error.toString());
        }
      }(),
      actions: [
        if (!kReleaseMode)
          TextButton(
            child: const Text("Override API"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const APIRootAlert(),
              );
            },
          ),
        TextButton(
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
