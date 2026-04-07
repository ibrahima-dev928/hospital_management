class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString(),
      senderId: json['sender_id'].toString(),
      senderName: json['sender_name'] ?? '',
      receiverId: json['receiver_id'].toString(),
      receiverName: json['receiver_name'] ?? '',
      content: json['content'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['is_read'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender_id': senderId,
        'sender_name': senderName,
        'receiver_id': receiverId,
        'receiver_name': receiverName,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'is_read': isRead ? 1 : 0,
      };
}

class Conversation {
  final String otherUserId;
  final String otherUserName;
  final String otherUserSpecialty;
  final String? otherUserAvatar;
  final Message lastMessage;
  final int unreadCount;

  Conversation({
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserSpecialty,
    this.otherUserAvatar,
    required this.lastMessage,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      otherUserId: json['other_user_id'].toString(),
      otherUserName: json['other_user_name'] ?? '',
      otherUserSpecialty: json['other_user_specialty'] ?? '',
      otherUserAvatar: json['other_user_avatar'],
      lastMessage: Message.fromJson(json['last_message']),
      unreadCount: json['unread_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'other_user_id': otherUserId,
        'other_user_name': otherUserName,
        'other_user_specialty': otherUserSpecialty,
        'other_user_avatar': otherUserAvatar,
        'last_message': lastMessage.toJson(),
        'unread_count': unreadCount,
      };
}
