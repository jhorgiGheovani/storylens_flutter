import 'package:shared_preferences/shared_preferences.dart';
import 'package:storylens/data/remote/api/api_service.dart';
import 'package:storylens/data/remote/model/general_post_response.dart';
import 'package:storylens/data/remote/model/login_response.dart';

class AuthRepository {
  final String tokenKey = 'TOKEN';

  Future<GeneralPostResponse> registerUser(
      String name, String email, String password) async {
    try {
      final apiService = ApiService();
      return await apiService.registerUser(name, email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse> loginUser(String email, String password) async {
    try {
      final apiService = ApiService();
      return await apiService.loginUser(email, password);
    } catch (e) {
      rethrow;
    }
  }

  //PREFERENCE
  Future setLoginToken(String token) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(tokenKey, token);
  }

  Future<bool> isTokenNotEmpty() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(
        seconds:
            2)); //buat nampilin splashscreen, splash screen akan ditampilin selama 3 detik
    final storedToken = sharedPreferences.getString(tokenKey);
    return storedToken != null &&
        storedToken
            .isNotEmpty; //if token key is not null and is not empty then return true otherwise return false
  }
  //SKENARIO
  //check apakah token null atau empty
  //if yes then go to login page
  //if no (token is present and not empty) then go to main page
  //setelah user memasukan data login dengan tepat maka set token to return value token from api request

  //logout
  //set token to empty
}
