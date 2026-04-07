import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hospital_management/screens/patient/chat_screen.dart';
import 'package:hospital_management/theme/app_theme.dart';

class ChatListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> conversations = [
    {
      'name': 'Dr. Ibrahim Al-Sallal',
      'lastMessage': 'Your test results are ready',
      'time': '2 min ago',
      'unread': true,
      'avatar': null,
      'specialty': 'Gastroenterologist',
    },
    {
      'name': 'Dr. Yusuf Khan',
      'lastMessage': 'Please confirm your appointment',
      'time': '1 hour ago',
      'unread': false,
      'avatar': null,
      'specialty': 'Cardiologist',
    },
    {
      'name': 'Dr. Salma Al-Sallal',
      'lastMessage': 'Thank you for visiting',
      'time': 'Yesterday',
      'unread': false,
      'avatar': null,
      'specialty': 'Dermatologist',
    },
  ];

  ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final chat = conversations[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    doctorName: chat['name'],
                    doctorSpecialty: chat['specialty'],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        backgroundImage: chat['avatar'] != null
                            ? NetworkImage(chat['avatar'])
                            : null,
                        child: chat['avatar'] == null
                            ? Text(
                                chat['name'][0],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppTheme.primaryColor,
                                ),
                              )
                            : null,
                      ),
                      if (chat['unread'])
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat['specialty'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat['lastMessage'],
                          style: TextStyle(
                            color: chat['unread']
                                ? AppTheme.textPrimary
                                : Colors.grey[500],
                            fontWeight: chat['unread']
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat['time'],
                        style: TextStyle(
                          color: chat['unread']
                              ? AppTheme.primaryColor
                              : Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                      if (chat['unread'])
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
