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
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // Adjust duration as needed
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Adjust curve as needed
    ));
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
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
                child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'images/login.png',
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  "Welcome \nBack!",
                  style: myTextTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: InputFields(
                      controller: emailController,
                      hint: "Email",
                      isPassword: false)),
              Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: InputFields(
                      controller: passwordController,
                      hint: "Password",
                      isPassword: true)),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                child: SizedBox(
                    width: double.infinity,
                    height: 45, // Set your desired width
                    child: context.watch<AuthProvider>().isLoadingLogin
                        ? const Center(child: CircularProgressIndicator())
                        : TextButton(
                            onPressed: () async {
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              final authProvider = context.read<AuthProvider>();
                              await authProvider.loginUser(emailController.text,
                                  passwordController.text);

                              if (authProvider.state == SubmitState.success) {
                                widget.onLogin();
                              } else if (authProvider.state ==
                                  SubmitState.error) {
                                scaffoldMessenger.showSnackBar(SnackBar(
                                  content:
                                      Text(authProvider.loginResponse!.message),
                                ));
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue), // Set the background color
                            ),
                            child: const Text(
                              "Sign in",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => widget.onRegister(),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ))));
  }
}
