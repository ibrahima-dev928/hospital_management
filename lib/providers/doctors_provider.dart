import 'package:flutter/material.dart';
import 'package:hospital_management/models/user.dart';
import 'package:hospital_management/services/api_service.dart';

class DoctorsProvider extends ChangeNotifier {
  List<User> _doctors = [];
  bool _isLoading = false;
  String? _error;

  List<User> get doctors => _doctors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiService _apiService = ApiService();

  Future<void> fetchDoctors({String? specialty}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Supposons que votre backend a une route /doctors
      final response = await _apiService.get('/doctors');
      if (response['success'] == true) {
        List<dynamic> list = response['doctors'] ?? [];
        _doctors = list.map((json) => User.fromJson(json)).toList();
        if (specialty != null && specialty != 'All') {
          _doctors =
              _doctors.where((d) => d.specialization == specialty).toList();
        }
      } else {
        _error = response['message'] ?? 'Failed to load doctors';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pour filtrage local (si déjà chargés)
  void filterBySpecialty(String specialty) {
    if (specialty == 'All') {
      fetchDoctors(); // recharger tout
    } else {
      // On peut soit recharger avec filtre, soit filtrer localement
      // Pour l'exemple, on refetch avec le paramètre
      fetchDoctors(specialty: specialty);
    }
  }
}
