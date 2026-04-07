import 'package:flutter/material.dart';
import 'package:hospital_management/models/message.dart';
import 'package:hospital_management/services/api_service.dart';

class MessageProvider extends ChangeNotifier {
  List<Conversation> _conversations = [];
  List<Message> _currentMessages = [];
  bool _isLoading = false;
  String? _error;

  List<Conversation> get conversations => _conversations;
  List<Message> get currentMessages => _currentMessages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiService _apiService = ApiService();

  Future<void> loadConversations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _conversations = await _apiService.getConversations();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMessages(String otherUserId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentMessages = await _apiService.getMessages(otherUserId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendMessage(String receiverId, String content) async {
    try {
      final newMessage = await _apiService.sendMessage(receiverId, content);
      if (newMessage != null) {
        _currentMessages.add(newMessage);
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to send message';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  void clearMessages() {
    _currentMessages.clear();
    notifyListeners();
  }
}
