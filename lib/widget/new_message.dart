import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessage();
}

class _NewMessage extends State<NewMessage> {
  final _messageController = TextEditingController();

  void _submitMessage() {
    //1.get entred text as String
    final entredText = _messageController.text;

    if (entredText.trim().isEmpty) {
      return;
    }
    //2. sent message to Firebase
    _messageController
        .clear(); //clear the message after the messgewill be submitted
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
              decoration: InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
