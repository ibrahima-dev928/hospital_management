import 'package:flutter/material.dart';
import 'package:hospital_management/models/appointment.dart';
import 'package:hospital_management/services/api_service.dart';

class AppointmentProvider extends ChangeNotifier {
  List<Appointment> _upcomingAppointments = [];
  List<Appointment> _pastAppointments = [];
  bool _isLoading = false;
  String? _error;

  List<Appointment> get upcomingAppointments => _upcomingAppointments;
  List<Appointment> get pastAppointments => _pastAppointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiService _apiService = ApiService();

  Future<void> loadAppointments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final appointments = await _apiService.getAppointments();
      _upcomingAppointments = appointments
          .where((a) => a.status == AppointmentStatus.upcoming)
          .toList();
      _pastAppointments = appointments
          .where((a) => a.status != AppointmentStatus.upcoming)
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Appointment?> createAppointment({
    required String doctorId,
    required DateTime dateTime,
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newAppt = await _apiService.createAppointment(
        doctorId: doctorId,
        dateTime: dateTime,
        notes: notes,
      );
      if (newAppt != null) {
        _upcomingAppointments.add(newAppt);
      }
      _isLoading = false;
      notifyListeners();
      return newAppt;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> cancelAppointment(String id) async {
    try {
      final success = await _apiService.cancelAppointment(id);
      if (success) {
        final index = _upcomingAppointments.indexWhere((a) => a.id == id);
        if (index != -1) {
          final cancelled = _upcomingAppointments[index]
              .copyWith(status: AppointmentStatus.cancelled);
          _upcomingAppointments.removeAt(index);
          _pastAppointments.add(cancelled);
          notifyListeners();
        }
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
