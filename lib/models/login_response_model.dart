import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

/// A model that represents the response of a login request.
/// ```json
/// {
/// "refresh": "string",
/// "access": "string"
/// }
/// ```
class LoginResponseModel {
  LoginResponseModel({
    required this.refresh,
    required this.access,
  });
  late final String refresh;
  late final String access;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    refresh = json['refresh'];
    access = json['access'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['refresh'] = refresh;
    data['access'] = access;
    return data;
  }
}
