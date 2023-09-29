import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/people_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chat_screen.dart';
import 'package:flutter/material.dart';

const String myUrl =
    'https://drive.google.com/file/d/1W0Qxnwk-wfgtJLaj5l1qxE3TVr6w_8xP/view?usp=drive_link';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final String url;

  late TabController? _tabController;

  final currentUser = FirebaseAuth.instance.currentUser!;

  String? userName;
  String? userEmail;
  String? userImage;

  @override
  void initState() {
    super.initState();
    _getUserData();

    _tabController = TabController(length: 2, vsync: this);
  }

  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(userId).get();

    if (!doc.exists) {
      throw Exception('User not found in Firestore!');
    }

    return doc.data() as Map<String, dynamic>;
  }

  void _getUserData() async {
    try {
      Map<String, dynamic> data = await fetchUserData(currentUser.uid);

      setState(() {
        userName = data['user_name'];
        userEmail = data['email'];
        userImage = data['image_url'];
      });
    } catch (e) {
      print('Failed to fetch user data: $e');
    }
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileScreen(
                userEmail: userEmail ?? "unknown",
                userName: userName ?? "unknown",
                userImage: userImage ?? '',
              )),
    );
  }

  _launchURL(String myUrl) async {
    final Uri url = Uri.parse(myUrl);

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $myUrl');
    }
  }

  _logOut() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'NatsApp',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
              color: Colors.white,
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 8.0),
                          Text('Profile'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          SizedBox(width: 8.0),
                          Text('Update app'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Row(
                        children: [
                          SizedBox(width: 8.0),
                          Text('Log Out'),
                        ],
                      ),
                    ),
                  ],
              onSelected: (value) async {
                switch (value) {
                  case 1:
                    try {
                      _navigateToProfile();
                    } catch (e) {
                      _showErrorDialog(context, 'Failed to save URL: $e');
                    }
                    break;
                  case 2:
                    {
                      try {
                        _launchURL(myUrl);
                      } catch (e) {
                        _showErrorDialog(context, 'Error: $e');
                      }
                    }
                    break;
                  case 3:
                    {
                      try {
                        // logout
                        _logOut();
                      } catch (e) {
                        _showErrorDialog(context, 'Error: $e');
                      }
                    }
                }
              })
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Icon(Icons.groups, color: Colors.white),
            Tab(
              child: Text(
                'Common Chat',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [PeopleScreen(), ChatScreen()],
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
