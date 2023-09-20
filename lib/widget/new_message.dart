import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessage();
}

class _NewMessage extends State<NewMessage> {
  final _messageController = TextEditingController();

  void _createPhoto() async {
    // 1. Make a photo
    final photo = await ImagePicker().pickImage(
        source: ImageSource.camera, imageQuality: 100, maxWidth: 150);

    // 2. Save the image in the File if it is not null
    if (photo == null) {
      return;
    }

    File _pickedImageFile =
        File(photo.path); // <-- Assign the photo to the file

    // 3. Save photo to Firebase store
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(DateTime.now().toString() + '.jpg');

    await storageRef
        .putFile(_pickedImageFile); // <-- Use the assigned file here

    // 4. Get the URL of the uploaded image
    final imageUrl = await storageRef.getDownloadURL();

    // 5. Send the image URL as a message to Firebase Chat collection
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'text': '',
      'userName': userData.data()!['user_name'],
      'userImage': userData.data()!['image_url'],
      'email': userData.data()!['email'],
    });
  }

  void _submitMessage() async {
    //1.get entred text as String
    final entredMessage = _messageController.text;

    if (entredMessage.trim().isEmpty) {
      return;
    }

    //2. close keyboard
    FocusScope.of(context).unfocus();

    //3.clear the message from the controller (no meaning to keep it in memory)
    _messageController.clear();

    //4. sent message to Firebase

    //4.1 get user id from Firebase
    final user = FirebaseAuth.instance.currentUser!;

    //4.2 get user data from Firebase (можно было локально сохранить данные и потом их использовать
    //но мы решили вытащить их из Firestore)
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': entredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData.data()!['user_name'],
      'userImage': userData.data()!['image_url'],
      'email': userData.data()!['email'],
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose(); //not occupade memory
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: const InputDecoration(
                    labelText: 'Send a message...',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 16)),
                style: const TextStyle(
                  // This line and the next two are the changes
                  color: Colors.white,
                  fontSize: 16.0,
                )),
          ),
          IconButton(
            onPressed: _createPhoto,
            icon: const Icon(
              Icons.photo_camera,
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          IconButton(
            onPressed: _submitMessage,
            icon: const Icon(
              Icons.send,
            ),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
