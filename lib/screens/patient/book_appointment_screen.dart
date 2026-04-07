import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:hospital_management/providers/appointment_provider.dart'; // Ajout de l'import manquant

class BookAppointmentScreen extends StatefulWidget {
  final String doctorId;
  const BookAppointmentScreen({super.key, required this.doctorId});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
  final notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Sélecteur de date
            ListTile(
              title: const Text('Date'),
              subtitle: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
              trailing: IconButton(
                icon: const Icon(Iconsax.calendar),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => selectedDate = date);
                },
              ),
            ),
            // Sélecteur d'heure
            ListTile(
              title: const Text('Time'),
              subtitle: Text(selectedTime.format(context)),
              trailing: IconButton(
                icon: const Icon(Iconsax.clock),
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (time != null) setState(() => selectedTime = time);
                },
              ),
            ),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final dateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                final success = await appointmentProvider.createAppointment(
                  doctorId: widget.doctorId,
                  dateTime: dateTime,
                  notes: notesController.text,
                );

                if (success != null && mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Appointment booked successfully')),
                  );
                }
              },
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
