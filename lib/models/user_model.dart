import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String avatarUrl;

  UserModel({required this.name, required this.avatarUrl});

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      name: doc['user_name'],
      avatarUrl: doc['image_url'],
    );
  }
}
