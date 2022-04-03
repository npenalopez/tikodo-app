class RegisterRequestModel {
  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.password2,
    required this.firstName,
    required this.lastName,
  });
  late final String email;
  late final String password;
  late final String password2;
  late final String firstName;
  late final String lastName;

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    password2 = json['password2'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['password2'] = password2;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
