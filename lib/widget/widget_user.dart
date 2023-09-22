import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class WidgetUser extends StatelessWidget {
  const WidgetUser({
    super.key,
    required this.user,
  });

  final UserModel user;

  _goToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ProfileScreen(
            userImage: user.avatarUrl,
            userName: user.name,
            userEmail: user.email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => _goToProfile(context),
        child: ListTile(
          leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl), radius: 23),
          title: Text(
            user.name,
            style: const TextStyle(fontSize: 16),
          ),
        ));
  }
}
