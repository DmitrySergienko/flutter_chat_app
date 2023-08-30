import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePicker();
}

class _UserImagePicker extends State<UserImagePicker> {
//save image in the File
  File? _pickedImageFile;

  void _imagePick() async {
    //1. make a image
    final picjedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    //2.sava the image in the File if it is not null
    if (picjedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(picjedImage.path);
    });

    widget.onPickImage(_pickedImageFile!); //
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: _imagePick,
          icon: Icon(Icons.image),
          label: Text(
            'Add image',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }
}
