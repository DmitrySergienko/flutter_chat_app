import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/widget/widget_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({
    super.key,
  });

  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsersFromFirebase();
  }

  _fetchUsersFromFirebase() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<UserModel> fetchedUsers =
        snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
    setState(() {
      users = fetchedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: const AssetImage('assets/images/people.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.1), // Adjust opacity as needed
                    BlendMode.dstATop))),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (ctx, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data!.docs
                  .map((doc) => UserModel.fromDocument(doc))
                  .toList();

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return WidgetUser(
                    user: users[index],
                    currentUserId: currentUserUid,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
