import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:storylens/data/auth_repository.dart';
import 'package:storylens/data/remote/api/general_post_response.dart';
import 'package:storylens/data/remote/model/login_response.dart';
import 'package:storylens/provider/states.dart';

class AuthProvider extends ChangeNotifier {
  // final ApiService apiService;
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  late GeneralPostResponse _registerUserResponse;
  late LoginResponse _loginResponse;
  late SubmitState _state;
  bool isLoadingLogin = false;

  String _message = '';

  String get message => _message;
  GeneralPostResponse? get registerUserResponse => _registerUserResponse;
  LoginResponse? get loginResponse => _loginResponse;
  SubmitState get state => _state;

  //register user function
  Future<dynamic> registerUser(
      String name, String email, String password) async {
    try {
      isLoadingLogin = true;
      notifyListeners();

      final register = await authRepository.registerUser(name, email, password);

      _registerUserResponse = register;
      isLoadingLogin = false;
      _state = SubmitState.success;
      notifyListeners();

      return register;
    } catch (e) {
      _state = SubmitState.error;
      isLoadingLogin = false;
      notifyListeners();
      if (e is ClientException) {
        return _message = 'Something wrong with your network!';
      } else {
        return _message = e.toString();
      }
    }
  }

  //login function
  Future<dynamic> loginUser(String email, String password) async {
    try {
      isLoadingLogin = true;
      notifyListeners();
      final loginPost = await authRepository.loginUser(email, password);

      _loginResponse = loginPost;
      await authRepository.setLoginToken(loginPost.loginResult!.token);
      isLoadingLogin = false;
      _state = SubmitState.success;

      notifyListeners();

      return loginPost;
    } catch (e) {
      _state = SubmitState.error;
      isLoadingLogin = false;
      notifyListeners();
      if (e is ClientException) {
        return _message = 'Something wrong with your network!';
      } else {
        return _message = e.toString();
      }
    }
  }
}
