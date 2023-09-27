import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/individual_chat_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class WidgetUser extends StatelessWidget {
  const WidgetUser({
    super.key,
    required this.user,
    //required this.currentUserId,
  });

  final UserModel user;
  // final String currentUserId;

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

  // String getChatId(String userId1, String userId2) {
  //   return [userId1, userId2]..sort().join("-");
  // }

  // _goToChat(BuildContext context, String recipientUserId) {
  //   final String chatId = getChatId(currentUserId, recipientUserId);
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (ctx) => IndividualChatScreen(chatId: chatId),
  //     ),
  //   );

  @override
  Widget build(BuildContext context) {
    return InkWell(
        // onTap: () => _goToChat(context, user.id),
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
