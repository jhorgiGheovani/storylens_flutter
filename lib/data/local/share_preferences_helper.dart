import 'package:shared_preferences/shared_preferences.dart';

class SharePreferenceHelper {
  final Future<SharedPreferences> sharedPreferences;

  SharePreferenceHelper({required this.sharedPreferences});

  static const tokenKey = 'TOKEN';

  Future setLoginToken(String token) async {
    final prefs = await sharedPreferences;
    prefs.setString(tokenKey, token);
  }

  Future<bool> isTokenKeyEmpty() async {
    final prefs = await sharedPreferences;
    final storedToken = prefs.getString(tokenKey);
    return storedToken == null ||
        storedToken
            .isEmpty; //if token is null or empty then it return true otherwise return false
  }
  //SKENARIO
  //check apakah token null atau empty
  //if yes then go to login page
  //if no (token is present and not empty) then go to main page
  //setelah user memasukan data login dengan tepat maka set token to return value token from api request

  //logout
  //set token to empty
}
