import 'package:chat_app/widget/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IndividulChatMessages extends StatelessWidget {
  const IndividulChatMessages({required this.chatId, super.key});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
        //dynamicly update like flow
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (cxt, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No messages found',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
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
              padding: const EdgeInsets.only(bottom: 40, left: 14, right: 14),
              reverse: true,
              itemCount: loadMessages.length,
              itemBuilder: (ctx, index) {
                final chatMessage = loadMessages[index].data();
                final nextMessage = index + 1 < loadMessages.length
                    ? loadMessages[index + 1].data()
                    : null;

                final currentMessageUserId = chatMessage['userId'];
                final nextMessageUserId =
                    nextMessage != null ? nextMessage['userId'] : null;
                final nextUserSame = currentMessageUserId == nextMessageUserId;

                // Check for imageUrl in the chatMessage
                final hasImageUrl = chatMessage.containsKey('imageUrl');

                if (nextUserSame) {
                  return MessageBubble.next(
                      message: chatMessage['text'],
                      chatImage: hasImageUrl ? chatMessage['imageUrl'] : null,
                      isMe: authUser.uid == currentMessageUserId);
                } else {
                  return MessageBubble.first(
                    userImage: chatMessage['userImage'],
                    username: chatMessage['userName'],
                    message: chatMessage['text'],
                    email: chatMessage['email'],
                    chatImage: hasImageUrl ? chatMessage['imageUrl'] : null,
                    isMe: authUser.uid == currentMessageUserId,
                  );
                }
              });
        });
  }
}
