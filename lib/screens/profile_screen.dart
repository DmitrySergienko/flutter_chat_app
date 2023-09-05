import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
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
                    backgroundImage: NetworkImage(userImage!),
                    backgroundColor: theme.colorScheme.primary.withAlpha(180),
                    radius: 90,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    userName!,
                    style: const TextStyle(fontSize: 22),
                  ),
                  Text(userEmail!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
