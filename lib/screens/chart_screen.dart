import 'package:chat_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  void _logOut() {
    firebase.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter chart'),
        actions: [
          IconButton(
            onPressed: _logOut,
            icon: const Icon(Icons.exit_to_app),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
      body: const Center(
        child: Text('Logged In'),
      ),
    );
  }
}
