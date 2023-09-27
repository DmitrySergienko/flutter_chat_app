import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/people_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'NatsApp',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                InkWell(
                    onTap: () async {
                      try {
                        //launch url
                        _launchURL(myUrl);
                      } catch (e) {
                        _showErrorDialog(context, 'Failed to save URL: $e');
                      }
                    },
                    child: const Icon(Icons.system_update_alt,
                        color: Colors.white)),
                const SizedBox(width: 8),
                InkWell(
                    onTap: () async {
                      try {
                        //launch url
                        _logOut();
                      } catch (e) {
                        _showErrorDialog(context, 'Error: $e');
                      }
                    },
                    child: const Icon(Icons.logout, color: Colors.white)),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Icon(Icons.groups, color: Colors.white),
            Tab(
              child: Text(
                'Общий Чат',
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
}
