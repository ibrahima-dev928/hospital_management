enum AppointmentStatus { upcoming, completed, cancelled, rescheduled }

class Appointment {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String specialization;
  final DateTime dateTime;
  final AppointmentStatus status;
  final String? notes;
  final String? meetingLink;
  final double? fee;

  Appointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.dateTime,
    required this.status,
    this.notes,
    this.meetingLink,
    this.fee,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'].toString(),
      patientId: json['patient_id'].toString(),
      patientName: json['patient_name'] ?? '',
      doctorId: json['doctor_id'].toString(),
      doctorName: json['doctor_name'] ?? '',
      specialization: json['specialization'] ?? '',
      dateTime: DateTime.parse(json['date_time']),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AppointmentStatus.upcoming,
      ),
      notes: json['notes'],
      meetingLink: json['meeting_link'],
      fee: (json['fee'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'patient_id': patientId,
        'patient_name': patientName,
        'doctor_id': doctorId,
        'doctor_name': doctorName,
        'specialization': specialization,
        'date_time': dateTime.toIso8601String(),
        'status': status.toString().split('.').last,
        'notes': notes,
        'meeting_link': meetingLink,
        'fee': fee,
      };

  // Pour copier avec modifications (utile pour annuler)
  Appointment copyWith({AppointmentStatus? status}) {
    return Appointment(
      id: id,
      patientId: patientId,
      patientName: patientName,
      doctorId: doctorId,
      doctorName: doctorName,
      specialization: specialization,
      dateTime: dateTime,
      status: status ?? this.status,
      notes: notes,
      meetingLink: meetingLink,
      fee: fee,
    );
  }
}
