import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hospital_management/theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final String doctorName;
  final String doctorSpecialty;

  const ChatScreen({
    super.key,
    required this.doctorName,
    required this.doctorSpecialty,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello, I have a question about my prescription',
      'isMe': true,
      'time': '10:30 AM',
    },
    {
      'text': 'Of course, how can I help you?',
      'isMe': false,
      'time': '10:32 AM',
    },
    {
      'text': 'I have some side effects from the medication',
      'isMe': true,
      'time': '10:33 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Text(
                widget.doctorName[0],
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctorName,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  widget.doctorSpecialty,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[_messages.length - 1 - index];
                return _buildMessage(msg['text'], msg['isMe'], msg['time']);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isMe, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) const SizedBox(width: 40),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppTheme.primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : const Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 10,
                      color: isMe ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Iconsax.attach_circle),
            onPressed: () {
              // Attach file
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.send_1),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                setState(() {
                  _messages.add({
                    'text': _messageController.text,
                    'isMe': true,
                    'time': 'Just now',
                  });
                });
                _messageController.clear();
              }
            },
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }
}
