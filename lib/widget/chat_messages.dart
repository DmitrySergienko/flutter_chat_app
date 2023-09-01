import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        //dynamicly update like flow
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: false)
            .snapshots(),
        builder: (cxt, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found'),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something wrong ...'),
            );
          }

          //count of messages in Firebase
          final loadMessages = snapshot.data!.docs;

          return ListView.builder(
              itemCount: loadMessages.length,
              itemBuilder: (ctx, index) =>
                  Text(loadMessages[index].data()['text']));
        });
  }
}
