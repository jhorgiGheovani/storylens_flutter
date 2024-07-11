// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storylens/provider/states.dart';
import 'package:storylens/provider/auth_provider.dart';
import 'package:storylens/style/style.dart';
import 'package:storylens/widgets/input_fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  final Function() onLogin;
  final Function() onRegister;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // Adjust duration as needed
    );
    _controller.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Stack(
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                  BlendMode.darken,
                ),
                child: Image.asset(
                  'images/loginbg.jpg', // Replace with your image asset
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Storylens",
                          style: myTextTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(3.0, 3.0),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Every Picture Tells a Story",
                          style: myTextTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(3.0, 3.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: InputFields(
                      controller: emailController,
                      hint: "Email",
                      isPassword: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: InputFields(
                      controller: passwordController,
                      hint: "Password",
                      isPassword: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50, // Set your desired height
                      child: context.watch<AuthProvider>().isLoadingLogin
                          ? const Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: () async {
                                final scaffoldMessenger =
                                    ScaffoldMessenger.of(context);
                                final authProvider =
                                    context.read<AuthProvider>();
                                await authProvider.loginUser(
                                    emailController.text,
                                    passwordController.text);

                                if (authProvider.state == SubmitState.success) {
                                  widget.onLogin();
                                } else if (authProvider.state ==
                                    SubmitState.error) {
                                  scaffoldMessenger.showSnackBar(SnackBar(
                                    content: Text(
                                        authProvider.loginResponse!.message),
                                  ));
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Sign in",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () => widget.onRegister(),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )));
  }
}
