import 'dart:io';

import 'package:chat_app/widget/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

final firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreen();
}

class _AuthScreen extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _entredEmail = '';
  var _entredPassword = '';
  var _entredUserName = '';

  //keep image
  File? _selectedImage;

  //compress image
  File compressImage(File imageFile) {
    final rawImage = img.decodeImage(imageFile.readAsBytesSync());
    final compressedImage = img.copyResize(rawImage!,
        width: 720); // You can adjust the width to your needs
    imageFile.writeAsBytesSync(img.encodeJpg(compressedImage,
        quality: 85)); // 85 is a good quality value, you can adjust as needed
    return imageFile;
  }

  //spiner
  var _isUploading = false;

  var _isLogin = true;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
    }

    if (_isLogin) {
      //log user in
      try {
        final userCredentions = await firebase.signInWithEmailAndPassword(
            email: _entredEmail, password: _entredPassword);
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'no message')));
      }
    } else {
      //create user by Firebase
      try {
        //start spiner while uploading data
        setState(() {
          _isUploading = true;
        });

        final userCredentions = await firebase.createUserWithEmailAndPassword(
            email: _entredEmail, password: _entredPassword);

        //save image in Firebase storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${userCredentions.user!.uid}.jpg');
        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        //save data in Firebase Firestore
        await FirebaseFirestore.instance
            .collection('users') //folder name in Firebase
            .doc(userCredentions.user!.uid) //file name in Firebase

            .set({
          //set data which we would like store
          'user_name': _entredUserName,
          'email': _entredEmail,
          'image_url': imageUrl
        });
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'no message')));
      }
      setState(() {
        _isLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //if the user signedUp
                            if (!_isLogin)
                              UserImagePicker(
                                onPickImage: (pickedImage) =>
                                    _selectedImage = compressImage(pickedImage),
                              ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Email Address'),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return "Please enter valid email address";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _entredEmail = value!;
                              },
                            ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Username'),
                                enableSuggestions: false,
                                onSaved: (value) {
                                  _entredUserName = value!;
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 3) {
                                    return 'Please eneter an valid name at least more then 3 characters';
                                  }
                                  return null;
                                },
                              ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return "Passwor must be at least 6 characters long";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _entredPassword = value!;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            if (_isUploading) const CircularProgressIndicator(),
                            if (!_isUploading)
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                child: Text(_isLogin ? 'Login' : 'Signup'),
                              ),
                            //if _isLogin is true "I have an account" or "create"
                            if (!_isUploading) //кнопка будет показана только если загрузка false
                              TextButton(
                                onPressed: () {
                                  //переключалка между состояниями, если _islogin is true -> false
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child:
                                    Text(_isLogin ? 'Create account' : 'Login'),
                              )
                          ],
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
