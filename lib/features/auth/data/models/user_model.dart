import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String name;
  final String email;
  final String uId;
  UserModel({required this.name, required this.email, required this.uId});

  factory UserModel.fromFirebaseAuth(User user) => UserModel(
    name: user.displayName ?? '',
    email: user.email ?? '',
    uId: user.uid,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(name: json['name'], email: json['email'], uId: json['uId']);

  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'uId': uId};
}
