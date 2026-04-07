import 'package:dio/dio.dart';
import 'package:hospital_management/models/user.dart';
import 'package:hospital_management/models/appointment.dart';
import 'package:hospital_management/models/message.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  late Dio _dio;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl:
          'http://10.130.91.63:8000/api', // pour Android emulator, changez selon votre serveur
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    // Intercepteur pour ajouter le token JWT
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // TODO: récupérer le token depuis SharedPreferences
        // String? token = prefs.getString('token');
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        return handler.next(options);
      },
    ));
  }

  // Getters pour les providers
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(String endpoint,
      {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      // Le serveur a répondu avec un code d'erreur
      return 'Erreur serveur: ${e.response?.statusCode} - ${e.response?.data['message'] ?? e.message}';
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Timeout de connexion';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'Impossible de se connecter au serveur';
    } else {
      return 'Erreur inconnue: ${e.message}';
    }
  }

  // Méthodes spécifiques à l'API
  Future<User?> login(String email, String password) async {
    try {
      final data =
          await post('/login', data: {'email': email, 'password': password});
      if (data['success'] == true) {
        // Stocker le token si fourni
        // final token = data['token'];
        // await _saveToken(token);
        return User.fromJson(data['user']);
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<User?> register(
      String name, String email, String password, String phone) async {
    try {
      final data = await post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'user_type': 'patient',
      });
      if (data['success'] == true) {
        return User.fromJson(data['user']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Appointment>> getAppointments() async {
    try {
      final data = await get('/appointments');
      if (data['success'] == true) {
        List<dynamic> list = data['appointments'];
        return list.map((json) => Appointment.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Appointment?> createAppointment({
    required String doctorId,
    required DateTime dateTime,
    String? notes,
  }) async {
    try {
      final data = await post('/appointments', data: {
        'doctor_id': doctorId,
        'date_time': dateTime.toIso8601String(),
        'notes': notes,
      });
      if (data['success'] == true) {
        return Appointment.fromJson(data['appointment']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> cancelAppointment(String id) async {
    try {
      final data = await put('/appointments/$id/cancel');
      return data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Conversation>> getConversations() async {
    try {
      final data = await get('/conversations');
      if (data['success'] == true) {
        List<dynamic> list = data['conversations'];
        return list.map((json) => Conversation.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Message>> getMessages(String otherUserId) async {
    try {
      final data = await get('/messages/$otherUserId');
      if (data['success'] == true) {
        List<dynamic> list = data['messages'];
        return list.map((json) => Message.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Message?> sendMessage(String receiverId, String content) async {
    try {
      final data = await post('/messages', data: {
        'receiver_id': receiverId,
        'content': content,
      });
      if (data['success'] == true) {
        return Message.fromJson(data['message']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
