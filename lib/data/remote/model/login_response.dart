import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool error;
  final String message;
  final LoginResult? loginResult;

  LoginResponse({
    required this.error,
    required this.message,
    this.loginResult,
  });
  factory LoginResponse.fromJson(json) => _$LoginResponseFromJson(json);
  // factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
  //       error: json["error"],
  //       message: json["message"],
  //       loginResult: json["loginResult"] != null
  //           ? LoginResult.fromJson(json["loginResult"])
  //           : null,
  //     );
}

@JsonSerializable()
class LoginResult {
  final String userId;
  final String name;
  final String token;

  LoginResult({
    required this.userId,
    required this.name,
    required this.token,
  });

  factory LoginResult.fromJson(json) => _$LoginResultFromJson(json);
}
