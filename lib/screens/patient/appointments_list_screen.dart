import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hospital_management/providers/appointment_provider.dart';
import 'package:hospital_management/theme/app_theme.dart';
import 'package:hospital_management/screens/patient/appointment_details_screen.dart';
import 'package:hospital_management/models/appointment.dart';

class AppointmentsListScreen extends StatefulWidget {
  const AppointmentsListScreen({super.key});

  @override
  State<AppointmentsListScreen> createState() => _AppointmentsListScreenState();
}

class _AppointmentsListScreenState extends State<AppointmentsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, ap, child) {
          if (ap.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (ap.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(ap.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ap.loadAppointments(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return TabBarView(
            controller: _tabController,
            children: [
              // Upcoming tab
              _buildAppointmentList(ap.upcomingAppointments),
              // Past tab
              _buildAppointmentList(ap.pastAppointments),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search-doctors');
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }

  Widget _buildAppointmentList(List<dynamic> appointments) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.calendar_remove, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No appointments',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Book a new appointment',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentDetailsScreen(
                  appointment: appointment.toJson(),
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                  child: Text(
                    appointment.doctorName[0],
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.specialization,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Iconsax.calendar,
                              size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM d, yyyy')
                                .format(appointment.dateTime),
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                          Icon(Iconsax.clock,
                              size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('h:mm a').format(appointment.dateTime),
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: appointment.status == AppointmentStatus.upcoming
                        ? Colors.green.withValues(alpha: 0.1)
                        : appointment.status == AppointmentStatus.completed
                            ? Colors.blue.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment.status.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: appointment.status == AppointmentStatus.upcoming
                          ? Colors.green
                          : appointment.status == AppointmentStatus.completed
                              ? Colors.blue
                              : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
