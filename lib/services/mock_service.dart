import 'dart:async';
import 'package:hospital_management/models/appointment.dart';
import 'package:hospital_management/models/message.dart';
import 'package:hospital_management/models/user.dart';

class MockService {
  static final MockService _instance = MockService._internal();
  factory MockService() => _instance;
  MockService._internal() {
    _init();
  }

  // Données simulées
  User? currentUser;
  List<User> doctors = [];
  List<Appointment> appointments = [];
  List<Message> messages = [];

  // Map des frais des médecins (car User n'a pas de champ fee)
  final Map<int, double> _doctorFees = {
    1: 50.0,
    2: 75.0,
    3: 60.0,
  };

  void _init() {
    // Médecins
    doctors = [
      User(
        id: 1,
        name: 'Dr. Ibrahim Al-Sallal',
        email: 'ibrahim@example.com',
        phone: '+965 1234 5678',
        userType: 'doctor',
        specialization: 'Gastroenterologist',
        experience: 16,
        rating: 4.8,
      ),
      User(
        id: 2,
        name: 'Dr. Yusuf Khan',
        email: 'yusuf@example.com',
        phone: '+965 2345 6789',
        userType: 'doctor',
        specialization: 'Cardiologist',
        experience: 12,
        rating: 4.9,
      ),
      User(
        id: 3,
        name: 'Dr. Salma Al-Sallal',
        email: 'salma@example.com',
        phone: '+965 3456 7890',
        userType: 'doctor',
        specialization: 'Dermatologist',
        experience: 8,
        rating: 4.7,
      ),
    ];

    // Utilisateur courant
    currentUser = User(
      id: 101,
      name: 'Salem Al-Ali',
      email: 'salem@email.com',
      phone: '+965 1234 5678',
      userType: 'patient',
    );

    // Rendez-vous (IDs en String)
    appointments = [
      Appointment(
        id: '1',
        patientId: '101',
        patientName: 'Salem Al-Ali',
        doctorId: '1',
        doctorName: 'Dr. Ibrahim Al-Sallal',
        specialization: 'Gastroenterologist',
        dateTime: DateTime.now().add(const Duration(days: 1)),
        status: AppointmentStatus.upcoming,
        notes: 'Please bring previous reports',
        fee: 50.0,
      ),
      Appointment(
        id: '2',
        patientId: '101',
        patientName: 'Salem Al-Ali',
        doctorId: '2',
        doctorName: 'Dr. Yusuf Khan',
        specialization: 'Cardiologist',
        dateTime: DateTime.now().add(const Duration(days: 3)),
        status: AppointmentStatus.upcoming,
        fee: 75.0,
      ),
    ];

    // Messages
    messages = [
      Message(
        id: '1',
        senderId: '1',
        senderName: 'Dr. Ibrahim Al-Sallal',
        receiverId: '101',
        receiverName: 'Salem Al-Ali',
        content: 'Your test results are ready',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        isRead: false,
      ),
      Message(
        id: '2',
        senderId: '2',
        senderName: 'Dr. Yusuf Khan',
        receiverId: '101',
        receiverName: 'Salem Al-Ali',
        content: 'Please confirm your appointment',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
    ];
  }

  // Méthodes d'authentification
  Future<User?> login(String email, String password) async {
    if (email == 'salem@email.com' && password == 'password') {
      return currentUser;
    }
    return null;
  }

  Future<User?> register(
      String name, String email, String password, String phone) async {
    currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      email: email,
      phone: phone,
      userType: 'patient',
    );
    return currentUser;
  }

  // Rendez-vous
  Future<List<Appointment>> getAppointments({AppointmentStatus? status}) async {
    if (status != null) {
      return appointments.where((a) => a.status == status).toList();
    }
    return appointments;
  }

  Future<Appointment> getAppointmentById(String id) async {
    return appointments.firstWhere((a) => a.id == id);
  }

  Future<Appointment> createAppointment({
    required String doctorId,
    required DateTime dateTime,
    String? notes,
  }) async {
    final doctor = doctors.firstWhere((d) => d.id.toString() == doctorId);
    final newAppointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: currentUser!.id.toString(),
      patientName: currentUser!.name,
      doctorId: doctorId,
      doctorName: doctor.name,
      specialization: doctor.specialization!,
      dateTime: dateTime,
      status: AppointmentStatus.upcoming,
      notes: notes,
      fee: _doctorFees[doctor.id] ?? 50.0,
    );
    appointments.add(newAppointment);
    return newAppointment;
  }

  Future<void> cancelAppointment(String id) async {
    final index = appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      final a = appointments[index];
      // Créer une nouvelle instance avec statut annulé (pas de copyWith)
      appointments[index] = Appointment(
        id: a.id,
        patientId: a.patientId,
        patientName: a.patientName,
        doctorId: a.doctorId,
        doctorName: a.doctorName,
        specialization: a.specialization,
        dateTime: a.dateTime,
        status: AppointmentStatus.cancelled,
        notes: a.notes,
        fee: a.fee,
      );
    }
  }

  // Messages
  Future<List<Conversation>> getConversations() async {
    final Map<String, List<Message>> grouped = {};
    for (var msg in messages) {
      final otherId = msg.senderId == currentUser!.id.toString()
          ? msg.receiverId
          : msg.senderId;
      grouped.putIfAbsent(otherId, () => []).add(msg);
    }

    return grouped.entries.map((entry) {
      final otherId = entry.key;
      final msgs = entry.value
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      final lastMsg = msgs.first;
      final otherName = lastMsg.senderId == otherId
          ? lastMsg.senderName
          : lastMsg.receiverName;

      // Compter les messages non lus
      final unread = msgs
          .where((m) => m.receiverId == currentUser!.id.toString() && !m.isRead)
          .length;

      // Récupérer la spécialité si c'est un docteur
      String specialty = '';
      try {
        final doctor = doctors.firstWhere((d) => d.id.toString() == otherId,
            orElse: () => User(
                id: int.tryParse(otherId) ?? 0,
                name: otherName,
                email: '',
                phone: '',
                userType: 'doctor'));
        specialty = doctor.specialization ?? '';
      } catch (e) {
        specialty = '';
      }

      return Conversation(
        otherUserId: otherId,
        otherUserName: otherName,
        otherUserSpecialty: specialty,
        otherUserAvatar: null,
        lastMessage: lastMsg,
        unreadCount: unread,
      );
    }).toList();
  }

  Future<List<Message>> getMessages(String otherUserId) async {
    return messages
        .where((m) =>
            (m.senderId == currentUser!.id.toString() &&
                m.receiverId == otherUserId) ||
            (m.senderId == otherUserId &&
                m.receiverId == currentUser!.id.toString()))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<Message> sendMessage(String receiverId, String content) async {
    final receiver = doctors.firstWhere((d) => d.id.toString() == receiverId,
        orElse: () => User(
            id: int.tryParse(receiverId) ?? 0,
            name: 'Inconnu',
            email: '',
            phone: '',
            userType: 'doctor'));

    final newMsg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUser!.id.toString(),
      senderName: currentUser!.name,
      receiverId: receiverId,
      receiverName: receiver.name,
      content: content,
      timestamp: DateTime.now(),
      isRead: false,
    );
    messages.add(newMsg);
    return newMsg;
  }
}

// Définition de Conversation si elle n'existe pas ailleurs
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
}
