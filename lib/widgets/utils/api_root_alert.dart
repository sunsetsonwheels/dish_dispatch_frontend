import 'package:dish_dispatch/widgets/utils/error_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIRootAlert extends StatefulWidget {
  const APIRootAlert({super.key});

  @override
  State<APIRootAlert> createState() => _APIRootAlertState();
}

class _APIRootAlertState extends State<APIRootAlert> {
  late final Future<SharedPreferences> prefs;
  final formKey = GlobalKey<FormState>();
  final urlController = TextEditingController();

  @override
  void initState() {
    prefs = SharedPreferences.getInstance();
    super.initState();
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget title = const Text("Change API Root");
    Widget cancel = TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text("Cancel"),
    );

    return FutureBuilder(
      future: prefs,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return AlertDialog(
            title: title,
            content: const Center(
              child: CircularProgressIndicator(),
            ),
            actions: [cancel],
          );
        }
        SharedPreferences prefs = snapshot.requireData;
        urlController.text = prefs.getString("apiRoot") ?? "";
        return AlertDialog(
          title: title,
          content: TextField(
            controller: urlController,
            autocorrect: false,
            keyboardType: TextInputType.url,
          ),
          actions: [
            cancel,
            TextButton(
              onPressed: () async {
                try {
                  if (urlController.text.isEmpty) {
                    throw Exception("URL cannot be empty!");
                  }
                  Uri.http(urlController.text);
                  await prefs.setString("apiRoot", urlController.text);
                  SystemNavigator.pop();
                } catch (error) {
                  showDialog(
                    context: context,
                    builder: (_) => ErrorAlertWidget(error: error),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
