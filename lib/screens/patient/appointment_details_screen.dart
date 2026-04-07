import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:hospital_management/theme/app_theme.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> appointment; // À remplacer par un modèle

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(appointment['dateTime']);
    final formattedDate = DateFormat('EEEE, MMM d, yyyy').format(date);
    final formattedTime = DateFormat('h:mm a').format(date);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      backgroundImage: appointment['doctorImage'] != null
                          ? NetworkImage(appointment['doctorImage'])
                          : null,
                      child: appointment['doctorImage'] == null
                          ? Text(
                              appointment['doctorName'][0],
                              style: TextStyle(
                                fontSize: 24,
                                color: AppTheme.primaryColor,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment['doctorName'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appointment['specialization'],
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Iconsax.star1,
                                  color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${appointment['rating']}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(width: 16),
                              const Icon(Iconsax.clock, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${appointment['experience']} yrs exp',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date and time
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.calendar_1, color: AppTheme.primaryColor),
                        const SizedBox(width: 12),
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Iconsax.clock, color: AppTheme.primaryColor),
                        const SizedBox(width: 12),
                        Text(
                          formattedTime,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Patient info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Patient Details',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Iconsax.user, size: 20),
                        const SizedBox(width: 12),
                        Text(appointment['patientName']),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Iconsax.note, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            appointment['notes'] ?? 'No additional notes',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Actions
            if (appointment['status'] == 'upcoming') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Reschedule
                      },
                      icon: const Icon(Iconsax.calendar_edit),
                      label: const Text('Reschedule'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Join video call
                      },
                      icon: const Icon(Iconsax.video),
                      label: const Text('Join Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    // Cancel appointment
                  },
                  icon: const Icon(Iconsax.trash, color: Colors.red),
                  label: const Text(
                    'Cancel Appointment',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ] else if (appointment['status'] == 'completed') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // View prescription / summary
                  },
                  icon: const Icon(Iconsax.document),
                  label: const Text('View Prescription'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
