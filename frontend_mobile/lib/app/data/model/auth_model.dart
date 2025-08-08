class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "username" : email,
    "password" : password
  };
}

class LoginResponseModel {
  final String accessToken;
  final String tokenType;

  LoginResponseModel({
    required this.accessToken,
    required this.tokenType,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}