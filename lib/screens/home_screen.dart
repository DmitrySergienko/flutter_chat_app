import 'package:chat_app/screens/people_screen.dart';

import 'chat_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
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
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
                onTap: () {
                  const snackBar = SnackBar(
                    content: Text(
                      'NatsApp ver 1.0.1 upd 22.09.23',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Icon(Icons.more_vert, color: Colors.white)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                'Chat',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16), // Set the color you want here.
              ),
            ),
            Icon(Icons.groups, color: Colors.white),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ChatScreen(), PeopleScreen()],
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
