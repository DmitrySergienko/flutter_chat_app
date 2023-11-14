import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widget/individual_chat_messages.dart';
import 'package:chat_app/widget/individual_new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

class IndividualChatScreen extends StatefulWidget {
  const IndividualChatScreen(
      {super.key,
      required this.chatId,
      required this.userId,
      required this.userImage,
      required this.userName,
      required this.userEmail});

  final String chatId;
  final String userId;
  final String userImage;
  final String userName;
  final String userEmail;

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  void setupNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.getAPNSToken();

    final token = await fcm.getToken();
    print('token: $token');

    // Store the token in Firestore. Assuming you have a users collection and a userId.
    final userId = widget.userId;

    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({'token': token}, SetOptions(merge: true));
    } catch (e) {
      print('Error updating token: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    //set up push notifications
    setupNotifications();
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileScreen(
                userEmail: widget.userEmail ?? "unknown",
                userName: widget.userName ?? "unknown",
                userImage: widget.userImage ?? '',
              )),
    );
  }

  _launchURL(String myUrl) async {
    final Uri url = Uri.parse(myUrl);

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $myUrl');
    }
  }

  _logOut() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userImage),
              radius: 23,
            ),
            const SizedBox(width: 8), // Spacing between the avatar and the name
            Expanded(
              // To make sure the name fits in the available space and doesn't overflow
              child: Text(
                widget.userName,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis, // In case the name is too long
              ),
            ),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
              color: Colors.white,
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Profile'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('Update app'),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text('Log Out'),
                    ),
                  ],
              onSelected: (value) async {
                switch (value) {
                  case 1:
                    _navigateToProfile();
                    break;
                  case 2:
                    _launchURL(myUrl);
                    break;
                  case 3:
                    _logOut();
                }
              })
        ],
      ),
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
