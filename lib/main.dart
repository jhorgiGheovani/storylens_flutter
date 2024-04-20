import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storylens/data/auth_repository.dart';
import 'package:storylens/data/main_repository.dart';
import 'package:storylens/provider/auth_provider.dart';
import 'package:storylens/provider/main_provider.dart';
import 'package:storylens/provider/page_manager.dart';
import 'package:storylens/routes/router_delegate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouterDelegate myRouterDelegate;

  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();
    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
              create: (_) => AuthProvider(authRepository: AuthRepository())),
          ChangeNotifierProvider<MainProvider>(
              create: (_) => MainProvider(mainRepository: MainRepository())),
          ChangeNotifierProvider<PageManager<double>>(
              create: (_) => PageManager())
        ],
        child: MaterialApp(
          title: 'Storylens',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: Router(
            routerDelegate: myRouterDelegate,
            backButtonDispatcher: RootBackButtonDispatcher(),
          ),
        ));
  }
}
