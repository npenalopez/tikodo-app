import 'dart:convert';

RegisterResponseModel registerResponseModel(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

/// A model that represents the response of a register request.
/// ```json
/// {
/// "email": "user@example.com",
/// "first_name": "string",
/// "last_name": "string"
/// }
/// ```
class RegisterResponseModel {
  RegisterResponseModel({
    required this.email,
    required this.firstName,
    required this.lastName,
  });
  late final String email;
  late final String firstName;
  late final String lastName;

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
