import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/widgets/utils/error_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoggingIn = false;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      APIProvider api = Provider.of<APIProvider>(context, listen: false);
      try {
        await api.saveCustomerAuth(
          phone: phoneController.text,
          password: passwordController.text,
        );
        await api.getCustomer();
        Routemaster.of(context).replace("/");
      } catch (error) {
        await api.logout();
        showDialog(
          context: context,
          builder: (_) => ErrorAlertWidget(error: error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          automaticallyImplyLeading: false,
        ),
        body: isLoggingIn
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: phoneController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: "Phone number",
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your phone number.";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.password),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.length < 4) {
                            return "Your password is too short.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: login,
                        child: const Text("Log in"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
