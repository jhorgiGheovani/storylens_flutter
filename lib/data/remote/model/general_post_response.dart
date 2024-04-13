class GeneralPostResponse {
  final bool error;
  final String message;
  final int statusCode;

  GeneralPostResponse(
      {required this.error, required this.message, required this.statusCode});

  factory GeneralPostResponse.fromJson(
          Map<String, dynamic> json, int statusCode) =>
      GeneralPostResponse(
          error: json["error"],
          message: json["message"],
          statusCode: statusCode);
}
