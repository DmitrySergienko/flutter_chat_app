import 'package:chat_app/screens/Home_screen.dart';
import 'package:chat_app/widget/individual_chat_messages.dart';
import 'package:chat_app/widget/individual_new_message.dart';
import 'package:chat_app/widget/new_message.dart';
import 'package:flutter/material.dart';

class IndividualChatScreen extends StatefulWidget {
  const IndividualChatScreen({super.key, required this.chatId});

  final String chatId;

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  _logOut() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
              onTap: () {
                _logOut();
              },
              child: const Icon(Icons.logout, color: Colors.white)),
        ),
      ]),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: const AssetImage('assets/images/backchat.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7), // Adjust opacity as needed
                    BlendMode.dstATop))),
        child: Column(
          children: [
            Expanded(
                child: IndividulChatMessages(
              chatId: widget.chatId,
            )),
            IndividualNewMessage(
              chatId: widget.chatId,
            )
          ],
        ),
      ),
    );
  }
}
