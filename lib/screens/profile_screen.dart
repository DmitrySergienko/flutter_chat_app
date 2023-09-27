import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    required this.userImage,
    required this.userName,
    required this.userEmail,
  }) : super(key: key);

  final String? userImage;
  final String? userName;
  final String? userEmail;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userImageUrl;

  Future<void> _makeNewAvatarPhoto() async {
    try {
      //1. create new photo
      final photo = await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 100, maxWidth: 640);

      // 2. save the image in the File if it is not null
      if (photo == null) {
        return;
      }

      File pickedImageFile =
          File(photo.path); // <-- Assign the photo to the file

      //3. save image in Firebase storage
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Handle the situation where the user is not authenticated
        return;
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${user.uid}.jpg');
      await storageRef.putFile(pickedImageFile);
      final imageUrl = await storageRef.getDownloadURL();

      user.updatePhotoURL(imageUrl);
      await user.reload();

      //4. Update the local state to refresh the UI
      setState(() {
        _userImageUrl = imageUrl;
      });
    } catch (error) {
      // Handle the error. You might want to show a user-friendly message
      print('Error updating profile photo: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _userImageUrl = widget.userImage; // Set initial image URL from widget
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please be aware'),
          content: const Text(
              'The avatar image has been updated successfully. To see the new image, please close and reopen the app.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Minimize main axis size
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(_userImageUrl!),
                    backgroundColor: theme.colorScheme.primary.withAlpha(180),
                    radius: 90,
                  ),
                  Tooltip(
                    message: "Change profile picture",
                    child: IconButton(
                        onPressed: () async {
                          //1.make new avatar
                          await _makeNewAvatarPhoto();
                          //2.show Alert diaslog
                          _showDialog(context);
                          //3. update state
                          initState();
                        },
                        icon: const Icon(Icons.photo_camera)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.userName!,
                    style: const TextStyle(fontSize: 22),
                  ),
                  Text(widget.userEmail!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
