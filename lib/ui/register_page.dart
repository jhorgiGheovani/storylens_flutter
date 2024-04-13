// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:storylens/provider/states.dart';
import 'package:storylens/provider/auth_provider.dart';
import 'package:storylens/style/style.dart';
import 'package:storylens/widgets/input_fields.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onLogin});

  final Function() onLogin;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'images/register.png',
                        height: 180,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Register",
                          style: myTextTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        )),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 10),
                        child: InputFields(
                            controller: nameController,
                            hint: "Name",
                            isPassword: false)),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 20),
                        child: InputFields(
                            controller: emailController,
                            hint: "Email",
                            isPassword: false)),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 20),
                        child: InputFields(
                            controller: passwordController,
                            hint: "Password",
                            isPassword: true)),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 15),
                        child: SizedBox(
                            width: double.infinity,
                            height: 45, // Set your desired width
                            child: context.watch<AuthProvider>().isLoadingLogin
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : TextButton(
                                    onPressed: () async {
                                      final scaffoldMessenger =
                                          ScaffoldMessenger.of(context);
                                      final authProvider =
                                          context.read<AuthProvider>();

                                      await authProvider.registerUser(
                                          nameController.text,
                                          emailController.text,
                                          passwordController.text);

                                      if (authProvider.state ==
                                          SubmitState.success) {
                                        scaffoldMessenger.showSnackBar(SnackBar(
                                          content: Text(authProvider
                                              .registerUserResponse!.message),
                                        ));
                                        handleLogin(
                                            authProvider, scaffoldMessenger);
                                      } else if (authProvider.state ==
                                          SubmitState.error) {
                                        scaffoldMessenger.showSnackBar(SnackBar(
                                          content: Text(authProvider
                                              .registerUserResponse!.message),
                                        ));
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all<Color>(Colors
                                              .blue), // Set the background color
                                    ),
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )))
                  ],
                ),
              )),
        )));
  }

  void handleLogin(AuthProvider authProvider,
      ScaffoldMessengerState scaffoldMessenger) async {
    //do this if register sukses
    if (authProvider.registerUserResponse?.statusCode == 201 ||
        authProvider.registerUserResponse?.statusCode == 200) {
      await authProvider.loginUser(
          emailController.text, passwordController.text);

      if (authProvider.state == SubmitState.success) {
        widget.onLogin();
      } else if (authProvider.state == SubmitState.error) {
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Text(authProvider.loginResponse!.message),
        ));
      }
    }
  }
}
