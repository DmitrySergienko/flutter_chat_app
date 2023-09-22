import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';

class WidgetUser extends StatelessWidget {
  const WidgetUser({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundImage: NetworkImage(user.avatarUrl), radius: 23),
      title: Text(
        user.name,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
