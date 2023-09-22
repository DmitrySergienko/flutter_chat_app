import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/widget/widget_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({
    super.key,
  });

  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
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
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return WidgetUser(
              user: users[index],
            );
          },
        ));
  }
}
