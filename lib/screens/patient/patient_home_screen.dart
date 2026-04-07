import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hospital_management/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:hospital_management/providers/appointment_provider.dart';
import 'package:hospital_management/providers/message_provider.dart';
import 'package:hospital_management/models/appointment.dart';
import 'package:hospital_management/models/message.dart';
import 'package:intl/intl.dart';
import 'package:hospital_management/screens/patient/appointment_details_screen.dart'; // pour la navigation
import 'package:hospital_management/screens/patient/chat_screen.dart'; // pour la navigation

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final searchController = TextEditingController();
  int selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().loadAppointments();
      context.read<MessageProvider>().loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildAppointmentSections(),
              const SizedBox(height: 20),
              _buildCategories(),
              const SizedBox(height: 20),
              _buildTodayAppointments(),
              const SizedBox(height: 20),
              _buildRecentMessages(),
              const SizedBox(height: 20),
              _buildRecommendedDoctors(),
              const SizedBox(height: 20),
              _buildEducationalVideos(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello,',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const Text(
              'Ibrahima Halilou',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Iconsax.wallet_3, size: 20),
              const SizedBox(width: 8),
              Text(
                '\$100.3',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Iconsax.search_normal, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search for Doctors or Specialties',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section des compteurs de rendez-vous (Upcoming/Past)
  Widget _buildAppointmentSections() {
    return Consumer<AppointmentProvider>(
      builder: (context, ap, child) {
        final upcomingCount = ap.upcomingAppointments.length;
        final pastCount = ap.pastAppointments.length;
        return Row(
          children: [
            Expanded(
              child: _buildAppointmentCard(
                'Upcoming',
                upcomingCount.toString(),
                Iconsax.calendar_1,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAppointmentCard(
                'Past',
                pastCount.toString(),
                Iconsax.clock,
                Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppointmentCard(
      String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'icon': Iconsax.health, 'label': 'General Health'},
      {'icon': Icons.child_care, 'label': 'Child Specialist'}, // Material Icon
      {'icon': Iconsax.brush, 'label': 'Skin & Hair'},
      {'icon': Icons.medical_services, 'label': 'Dental Care'}, // Material Icon
      {'icon': Iconsax.eye, 'label': 'Eye Specialist'},
      {'icon': Iconsax.hospital, 'label': 'Digestive Issues'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WHAT ARE YOU LOOKING FOR?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    categories[index]['icon'] as IconData,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    categories[index]['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Section des rendez-vous du jour
  Widget _buildTodayAppointments() {
    return Consumer<AppointmentProvider>(
      builder: (context, ap, child) {
        final today = DateTime.now();
        final todayAppointments = ap.upcomingAppointments
            .where((a) =>
                a.dateTime.year == today.year &&
                a.dateTime.month == today.month &&
                a.dateTime.day == today.day)
            .toList();

        if (ap.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "TODAY'S APPOINTMENTS",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/appointments');
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (todayAppointments.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'No appointments today',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: todayAppointments.map((appointment) {
                    return Column(
                      children: [
                        _buildAppointmentItem(
                          appointment.doctorName,
                          appointment.specialization,
                          DateFormat('h:mm a').format(appointment.dateTime),
                          _getTimeRemaining(appointment.dateTime),
                          appointment.patientName,
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
                        ),
                        if (appointment != todayAppointments.last)
                          const Divider(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }

  // Helper pour calculer le temps restant
  String _getTimeRemaining(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    if (difference.inMinutes < 60) {
      return 'in ${difference.inMinutes} mins';
    } else {
      return 'in ${difference.inHours} hrs ${difference.inMinutes % 60} mins';
    }
  }

  // Widget d'un élément de rendez-vous (avec onTap optionnel)
  Widget _buildAppointmentItem(
    String doctorName,
    String specialty,
    String time,
    String duration,
    String patient, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
            child: Text(
              doctorName[0],
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  specialty,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  'For: $patient',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section des messages récents
  Widget _buildRecentMessages() {
    return Consumer<MessageProvider>(
      builder: (context, mp, child) {
        if (mp.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final recentConversations = mp.conversations.take(2).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'NEW MESSAGES',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat-list');
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (recentConversations.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'No messages',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: recentConversations.map((conv) {
                    return Column(
                      children: [
                        _buildMessageItem(
                          conv.otherUserName,
                          _formatTime(conv.lastMessage.timestamp),
                          conv.lastMessage.content,
                          conv.unreadCount > 0,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  doctorName: conv.otherUserName,
                                  doctorSpecialty: conv.otherUserSpecialty,
                                ),
                              ),
                            );
                          },
                        ),
                        if (conv != recentConversations.last)
                          const Divider(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }

  // Helper pour formater la date/heure d'un message
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hour ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  // Widget d'un élément de message (avec onTap)
  Widget _buildMessageItem(
      String name, String time, String lastMessage, bool isUnread,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isUnread ? Colors.blue : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  lastMessage,
                  style: TextStyle(
                    color: isUnread ? AppTheme.textPrimary : Colors.grey[500],
                    fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: isUnread ? AppTheme.primaryColor : Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              if (isUnread)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedDoctors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '284 DOCTORS AVAILABLE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          AppTheme.primaryColor.withValues(alpha: 0.1),
                      child: const Icon(
                        Iconsax.user,
                        size: 30,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Dr. Ibrahim Al-Sallal',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Gastroenterologist',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Iconsax.star1,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '4.8',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Iconsax.clock,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '16 yrs exp',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEducationalVideos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VIDEOS ON GASTROENTEROLOGIST',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildVideoItem(
                'Natural Dietary Supplements',
                'Dr. Ahmad Al-Saleh',
              ),
              const Divider(height: 20),
              _buildVideoItem(
                'Skin Problems',
                'Dr. Ali Salleh',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoItem(String title, String doctor) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Iconsax.video_play,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'By: $doctor',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Iconsax.share,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedNavIndex,
        onTap: (index) {
          setState(() {
            selectedNavIndex = index;
          });
          // Navigation vers les pages correspondantes
          switch (index) {
            case 0:
              // Déjà sur home, on ne fait rien ou on pop jusqu'à home
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              break;
            case 1:
              Navigator.pushNamed(context, '/appointments');
              break;
            case 2:
              Navigator.pushNamed(context, '/chat-list');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.calendar),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
