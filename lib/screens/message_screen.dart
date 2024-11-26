import 'package:campuslostandfound/components/appbar/bottom_navbar.dart';
import 'package:campuslostandfound/components/appbar/items_app_bar.dart';
import 'package:campuslostandfound/services/message_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campuslostandfound/services/auth_state.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final MessageService _messageService = MessageService();
  final TextEditingController _messageController = TextEditingController();
  final String _adminId = "AlCetjGrQIdMUZsSURy2AFr9uFp1";

  int _selectedIndex = 2;

  final List<Map<String, dynamic>> _localMessages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _sendMessage(String? currentUserId) {
    if (_messageController.text.trim().isEmpty || currentUserId == null) {
      print('User is not logged in or message is empty');
      return;
    }

    print('Current User ID: $currentUserId');
    print('Current Admin ID: $_adminId');

    final newMessage = {
      'senderId': currentUserId,
      'receiverId': _adminId,
      'message': _messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    setState(() {
      _localMessages.insert(0, newMessage);
    });

    _messageService.sendMessage(
      senderId: currentUserId,
      receiverId: _adminId,
      message: _messageController.text.trim(),
    );

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final currentUserId = authState.user?.uid;

    return Scaffold(
      appBar: ItemsAppBar(
        child: const Center(
          child: Text(
            'Messages',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF002EB0),
            ),
          ),
        ),
        onBackButtonPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (Route<dynamic> route) => false,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messageService.fetchMessages(currentUserId ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages.'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isCurrentUser =
                          message['senderId'] == currentUserId;
                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Colors.blueAccent
                                : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12.0),
                              topRight: const Radius.circular(12.0),
                              bottomLeft: isCurrentUser
                                  ? const Radius.circular(12.0)
                                  : Radius.zero,
                              bottomRight: isCurrentUser
                                  ? Radius.zero
                                  : const Radius.circular(12.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                message['message'],
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                message['timestamp'] != null
                                    ? (message['timestamp'] is Timestamp
                                        ? DateFormat('MMM dd, yyyy HH:mm')
                                            .format((message['timestamp']
                                                    as Timestamp)
                                                .toDate())
                                        : DateFormat('MMM dd, yyyy HH:mm')
                                            .format(DateTime.parse(
                                                    message['timestamp'])
                                                .toLocal()))
                                    : 'Sending...',
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(currentUserId),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
