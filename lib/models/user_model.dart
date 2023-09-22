import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String avatarUrl;
  final String email;

  UserModel({
    required this.name,
    required this.avatarUrl,
    required this.email,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
        name: doc['user_name'],
        avatarUrl: doc['image_url'],
        email: doc['email']);
  }
}
