import 'package:dish_dispatch/widgets/utils/api_root_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorPlaceholderWidget extends StatelessWidget {
  final Object error;

  const ErrorPlaceholderWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 48),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (!kReleaseMode)
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const APIRootAlert(),
                ),
                child: const Text("Override API URL"),
              ),
          ],
        ),
      ),
    );
  }
}
