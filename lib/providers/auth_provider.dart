import 'package:flutter/material.dart';
import 'package:hospital_management/models/user.dart';
import 'package:hospital_management/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  final ApiService _apiService = ApiService();

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _apiService.login(email, password);
      if (user != null) {
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
      String name, String email, String password, String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _apiService.register(name, email, password, phone);
      if (user != null) {
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    // TODO: supprimer le token
    notifyListeners();
  }

  // Méthode à appeler au démarrage de l'app pour restaurer la session
  Future<void> loadUserFromStorage() async {
    // TODO: implémenter avec SharedPreferences
    // Pour l'instant, on ne fait rien
  }
}
