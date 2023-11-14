import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/widget/chat_messages.dart';
import 'package:chat_app/widget/new_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _logOut() {
    firebase.signOut();
  }

  void setupNotifications() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();
    fcm.getAPNSToken();

    final token = await fcm
        .getToken(); //if we would like to get acces to the individual device, we can use the token
    print('token: $token');

    //if we would like make a notification chanel
    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();

    //set up push notifications
    setupNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: const AssetImage('assets/images/backautumn.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), // Adjust opacity as needed
                    BlendMode.dstATop))),
        child: const Column(
          children: [Expanded(child: ChatMessages()), NewMessage()],
        ),
      ),
    );
  }
}
