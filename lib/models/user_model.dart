import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String email;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.email,
    required this.token,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
        id: doc.id,
        name: doc['user_name'],
        avatarUrl: doc['image_url'],
        email: doc['email'],
        token: doc['token']);
  }
}
