import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hospital_management/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:hospital_management/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // Icône de paramètres pour modifier le profil
          IconButton(
            icon: const Icon(Iconsax.setting_2),
            onPressed: () => _showEditProfileDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/150'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Salem Al-Ali',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'salem@email.com',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Personal info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(Iconsax.user, 'Full Name', 'Salem Al-Ali'),
                    _buildInfoRow(Iconsax.sms, 'Email', 'salem@email.com'),
                    _buildInfoRow(Iconsax.call, 'Phone', '+965 1234 5678'),
                    _buildInfoRow(
                        Iconsax.calendar, 'Date of Birth', '15 May 1985'),
                    _buildInfoRow(Iconsax.health, 'Blood Group', 'O+'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Wallet info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Wallet Balance',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          '\$100.3',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/wallet');
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(80, 35),
                          ),
                          child: const Text('Top up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Settings options
            Card(
              child: Column(
                children: [
                  _buildSettingTile(
                    Iconsax.lock,
                    'Change Password',
                    () => _showChangePasswordDialog(context),
                  ),
                  const Divider(height: 1),
                  _buildSettingTile(
                    Iconsax.notification,
                    'Notifications',
                    () => _showComingSoon(context, 'Notifications'),
                  ),
                  const Divider(height: 1),
                  _buildSettingTile(
                    Iconsax.security_card,
                    'Privacy',
                    () => _showPrivacyDialog(context),
                  ),
                  const Divider(height: 1),
                  _buildSettingTile(
                    Iconsax.info_circle,
                    'About',
                    () => _showAboutDialog(context),
                  ),
                  const Divider(height: 1),
                  _buildSettingTile(
                    Iconsax.logout,
                    'Sign Out',
                    () {
                      print('🟢 Sign Out button pressed');
                      context.read<AuthProvider>().logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap,
      {Color color = AppTheme.textPrimary}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // ========== Dialog methods ==========

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: 'Salem Al-Ali');
    final emailController = TextEditingController(text: 'salem@email.com');
    final phoneController = TextEditingController(text: '+965 1234 5678');
    final dobController = TextEditingController(text: '15 May 1985');
    final bloodGroupController = TextEditingController(text: 'O+');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.sms),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.call),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dobController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.calendar),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bloodGroupController,
                decoration: const InputDecoration(
                  labelText: 'Blood Group',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.health),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Ici on appellerait le service pour mettre à jour le profil
              // Pour l'instant, on simule la mise à jour
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated (simulated)')),
              );
              // Idéalement, on mettrait à jour l'affichage avec les nouvelles valeurs
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Ici on appellerait le service pour changer le mot de passe
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed (simulated)')),
              );
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(feature),
        content: Text('$feature feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text(
          'Your data is protected and used only for medical purposes. We do not share your information with third parties without your consent.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('About Health X'),
        content: const Text(
          'Health X - Your trusted healthcare companion\n\nVersion 1.0.0\n\nDeveloped by Your Company',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
