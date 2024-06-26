import 'package:flutter/material.dart';
import 'package:storylens/data/auth_repository.dart';
import 'package:storylens/ui/add_story_page.dart';
import 'package:storylens/ui/detail_page.dart';
import 'package:storylens/ui/home_page.dart';
import 'package:storylens/ui/login_page.dart';
import 'package:storylens/ui/maps_page.dart';
import 'package:storylens/ui/register_page.dart';
import 'package:storylens/ui/splash_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  List<Page> historyStack = [];
  bool? isTokenNotEmpty;
  bool isRegister = false;
  bool isAddStory = false;
  bool gotoMapsScreen = false;
  String? selectedItem;

  MyRouterDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isTokenNotEmpty = await authRepository.isTokenNotEmpty();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    //conditional untuk menenuntkan stack
    if (isTokenNotEmpty == null) {
      historyStack = _splashStack;
    } else if (isTokenNotEmpty == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }
        if (gotoMapsScreen == true) {
          return gotoMapsScreen = false;
        }
        isRegister =
            false; // if user press back button then isRegister set to false and user go to login Page
        selectedItem = null;
        isAddStory = false;

        notifyListeners();

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }

  //Stack halaman
  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashScreen"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
            key: const ValueKey("LoginPage"),
            child: LoginPage(
              onLogin: () {
                isTokenNotEmpty = true;
                notifyListeners();
              },
              onRegister: () {
                isRegister =
                    true; //if user click register button isRegister change to true
                notifyListeners();
              },
            )),

        //if isRegister is true then navigation will go to register page
        //by default isRegister is false
        if (isRegister == true)
          MaterialPage(
              key: const ValueKey("RegisterPage"),
              child: RegisterPage(
                onLogin: () {
                  isTokenNotEmpty = true; //auto login kalau data valid
                  notifyListeners();
                },
              ))
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
            key: const ValueKey("HomePage"),
            child: HomePage(onLogout: () async {
              await authRepository.setLoginToken("");
              isTokenNotEmpty = false;
              notifyListeners();
            }, onTapped: (String storyId) {
              selectedItem = storyId;
              notifyListeners();
            }, addStory: () {
              isAddStory = true;
              notifyListeners();
            })),
        if (isAddStory == true)
          MaterialPage(
              key: const ValueKey("AddStoryPage"),
              child: AddStoryPage(
                uploadSuccess: () {
                  isAddStory = false;

                  notifyListeners();
                },
                gotoMapsScreen: () {
                  gotoMapsScreen = true;
                  notifyListeners();
                },
              )),
        if (gotoMapsScreen == true)
          MaterialPage(
              key: const ValueKey("MapsScreen"),
              child: MapsScreen(
                backToAddStoryPage: () {
                  gotoMapsScreen = false;
                  notifyListeners();
                },
              )),
        if (selectedItem != null)
          MaterialPage(
            key: ValueKey(selectedItem),
            child: DetailPage(
              quoteId: selectedItem!,
            ),
          ),
      ];
}
