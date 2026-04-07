import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hospital_management/providers/auth_provider.dart';
import 'package:hospital_management/providers/doctors_provider.dart';
import 'package:hospital_management/screens/auth/login_screen.dart';
import 'package:hospital_management/screens/patient/patient_home_screen.dart';
import 'package:hospital_management/theme/app_theme.dart';
//providers
import 'package:hospital_management/providers/auth_provider.dart';
import 'package:hospital_management/providers/appointment_provider.dart';
import 'package:hospital_management/providers/message_provider.dart';

//screen
import 'screens/doctor/doctor_home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/patient/appointment_details_screen.dart';
import 'screens/patient/chat_list_screen.dart';
import 'screens/patient/chat_screen.dart';
import 'screens/patient/doctor_search_screen.dart';
import 'screens/patient/patient_home_screen.dart';
import 'screens/patient/profile_screen.dart';
import 'screens/patient/tests_screen.dart';
import 'screens/patient/wallet_screen.dart';
import 'screens/patient/book_appointment_screen.dart';
import 'screens/patient/appointments_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.loadUserFromStorage(); // charger le token au démarrage

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DoctorsProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        // autres providers
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return MaterialApp(
          title: 'Health X',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: Provider.of<AuthProvider>(context).isAuthenticated
              ? '/home'
              : '/login',
          home: auth.isAuthenticated
              ? const PatientHomeScreen()
              : const LoginScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const PatientHomeScreen(),
            '/appointment-details': (context) => AppointmentDetailsScreen(
                  appointment: {
                    'doctorName': 'Dr. Ibrahim Al-Sallal',
                    'specialization': 'Gastroenterologist',
                    'rating': 4.8,
                    'experience': 16,
                    'patientName': 'Salem Al-Ali',
                    'dateTime': '2026-03-03T15:30:00',
                    'status': 'upcoming',
                    'notes': 'Please bring your previous reports',
                  },
                ),
            '/chat-list': (context) => ChatListScreen(),
            '/chat': (context) => ChatScreen(
                  doctorName: 'Dr. Ibrahim Al-Sallal',
                  doctorSpecialty: 'Gastroenterologist',
                ),
            '/search-doctors': (context) => DoctorSearchScreen(),
            '/profile': (context) => ProfileScreen(),
            '/wallet': (context) => WalletScreen(),
            '/tests': (context) => TestsScreen(),
            '/appointments': (context) => const AppointmentsListScreen(),
            '/book-appointment': (context) {
              final doctorId =
                  ModalRoute.of(context)!.settings.arguments as String;
              return BookAppointmentScreen(doctorId: doctorId);
            },
          },
        );
      },
    );
  }
}
