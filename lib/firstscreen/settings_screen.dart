import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage:
                        NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Alex Rivera',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('alex.rivera@email.com',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined,
                        color: Color(0xFF2ECC71)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 2. Settings Sections
            _buildSectionTitle('Account Settings'),
            _buildSettingItem(
                Icons.person_outline, 'Personal Information', null),
            _buildSettingItem(
                Icons.account_balance_outlined, 'Bank Accounts', '3 linked'),

            const SizedBox(height: 20),

            _buildSectionTitle('Security & App'),
            _buildSettingItem(Icons.lock_outline, 'Change Password', null),
            _buildSettingItem(Icons.fingerprint, 'Biometric Lock', 'Enabled'),
            _buildSettingItem(Icons.notifications_none, 'Notifications', 'On'),
            _buildSettingItem(Icons.dark_mode_outlined, 'Dark Mode', 'Off'),

            const SizedBox(height: 20),

            _buildSectionTitle('Support'),
            _buildSettingItem(Icons.help_outline, 'Help Center', null),
            _buildSettingItem(Icons.info_outline, 'About App', 'v1.0.0'),

            // 3. Logout Button
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Logout',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget tiêu đề từng phần
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  // Widget từng dòng cài đặt
  Widget _buildSettingItem(IconData icon, String title, String? trailingText) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null)
              Text(trailingText, style: const TextStyle(color: Colors.grey)),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
