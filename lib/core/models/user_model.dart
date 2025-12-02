import 'package:hive_ce_flutter/adapters.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? password;

  @HiveField(3)
  String? countryName;

  @HiveField(4)
  String? countryCode;

  String? accessToken;

  String? refreshToken;

  UserModel({
    required this.name,
    this.email,
    this.password,
    this.countryName,
    this.countryCode,
    this.accessToken,
    this.refreshToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'countryName': countryName,
      'countryCode': countryCode,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      countryName: map['countryName'] as String,
      countryCode: map['countryCode'] as String,
    );
  }

  factory UserModel.fromAuthResponse(Map<String, dynamic> json, String username) {
    return UserModel(
      name: username,
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    String? countryName,
    String? countryCode,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      countryName: countryName ?? this.countryName,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  @override
  String toString() {
    return 'UserModel{name: $name, email: $email, password: $password, countryName: $countryName, countryCode: $countryCode, accessToken: $accessToken, refreshToken: $refreshToken}';
  }
}
