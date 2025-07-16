// File: lib/screens/child/settings_screen.dart
import 'package:flutter/material.dart';
import 'library_screen.dart';
import '../parent/parent_dashboard_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _autoPlayEnabled = false;
  double _readingGoalMinutes = 15.0;
  String _selectedVoice = 'Child Voice';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),
            
            // Settings content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Section
                    _buildSection(
                      'Profile',
                      [
                        _buildProfileTile(),
                        _buildSettingsTile(
                          Icons.edit,
                          'Change Avatar',
                          'Customize your profile picture',
                          onTap: () {
                            _showAvatarPicker();
                          },
                        ),
                        _buildSettingsTile(
                          Icons.security,
                          'Parent Controls',
                          'Access parental settings',
                          onTap: () {
                            _showParentPinDialog();
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Reading Settings
                    _buildSection(
                      'Reading',
                      [
                        _buildSwitchTile(
                          Icons.volume_up,
                          'Sound Effects',
                          'Enable reading sounds',
                          _soundEnabled,
                          (value) => setState(() => _soundEnabled = value),
                        ),
                        _buildSwitchTile(
                          Icons.play_arrow,
                          'Auto-play Stories',
                          'Automatically start reading aloud',
                          _autoPlayEnabled,
                          (value) => setState(() => _autoPlayEnabled = value),
                        ),
                        _buildSettingsTile(
                          Icons.record_voice_over,
                          'Reading Voice',
                          _selectedVoice,
                          onTap: () {
                            _showVoiceSelector();
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Goals Section
                    _buildSection(
                      'Goals',
                      [
                        _buildSliderTile(
                          Icons.timer,
                          'Daily Reading Goal',
                          '${_readingGoalMinutes.round()} minutes per day',
                          _readingGoalMinutes,
                          5.0,
                          60.0,
                          (value) => setState(() => _readingGoalMinutes = value),
                        ),
                        _buildSettingsTile(
                          Icons.emoji_events,
                          'View Achievements',
                          'See your reading badges',
                          onTap: () {
                            _showAchievements();
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Notifications
                    _buildSection(
                      'Notifications',
                      [
                        _buildSwitchTile(
                          Icons.notifications,
                          'Reading Reminders',
                          'Get reminded to read daily',
                          _notificationsEnabled,
                          (value) => setState(() => _notificationsEnabled = value),
                        ),
                        _buildSettingsTile(
                          Icons.access_time,
                          'Reminder Time',
                          '6:00 PM',
                          onTap: () {
                            _showTimePicker();
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // About Section
                    _buildSection(
                      'About',
                      [
                        _buildSettingsTile(
                          Icons.help_outline,
                          'Help & Support',
                          'Get help with the app',
                          onTap: () {
                            _showHelpDialog();
                          },
                        ),
                        _buildSettingsTile(
                          Icons.info_outline,
                          'About ReadMe',
                          'Version 1.0.0',
                          onTap: () {
                            _showAboutDialog();
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, 'Home', false),
            _buildNavItem(Icons.library_books, 'Library', false),
            _buildNavItem(Icons.settings, 'Settings', true),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8E44AD),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTile() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF8E44AD).withOpacity(0.1),
              border: Border.all(
                color: const Color(0xFF8E44AD),
                width: 2,
              ),
            ),
            child: const Center(
              child: Text(
                '👦',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Young Reader',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Level 3 Explorer',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF8E44AD),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              '🌟 12',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8E44AD)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8E44AD)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF8E44AD),
      ),
    );
  }

  Widget _buildSliderTile(IconData icon, String title, String subtitle, double value, double min, double max, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF8E44AD)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / 5).round(),
            activeColor: const Color(0xFF8E44AD),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (label == 'Home' && !isActive) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (label == 'Library' && !isActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LibraryScreen()),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF8E44AD) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF8E44AD) : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Dialog functions
  void _showAvatarPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Avatar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption('👦'),
                _buildAvatarOption('👧'),
                _buildAvatarOption('🧒'),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption('🦸‍♂️'),
                _buildAvatarOption('🦸‍♀️'),
                _buildAvatarOption('👨‍🚀'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarOption(String emoji) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Avatar changed to $emoji'),
            backgroundColor: const Color(0xFF8E44AD),
          ),
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF8E44AD).withOpacity(0.1),
          border: Border.all(color: const Color(0xFF8E44AD)),
        ),
        child: Center(
          child: Text(emoji, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  void _showParentPinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Parent Controls'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter parent PIN to access advanced settings'),
            SizedBox(height: 15),
            TextField(
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter PIN',
                border: OutlineInputBorder(),
              ),
              maxLength: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to parent dashboard
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParentDashboardScreen(),
                ),
              );
            },
            child: const Text('Access'),
          ),
        ],
      ),
    );
  }

  void _showVoiceSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Reading Voice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Child Voice'),
              value: 'Child Voice',
              groupValue: _selectedVoice,
              onChanged: (value) {
                setState(() => _selectedVoice = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Adult Voice'),
              value: 'Adult Voice',
              groupValue: _selectedVoice,
              onChanged: (value) {
                setState(() => _selectedVoice = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    ).then((time) {
      if (time != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder set for ${time.format(context)}'),
            backgroundColor: const Color(0xFF8E44AD),
          ),
        );
      }
    });
  }

  void _showAchievements() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Achievements'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🏆 First Book Read'),
            Text('📚 Book Lover (5 books)'),
            Text('🔥 3-Day Reading Streak'),
            Text('⭐ 100 Minutes Read'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('Need help? Contact us at support@readmeapp.com'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About ReadMe'),
        content: const Text('ReadMe - A persuasive reading app for kids\nVersion 1.0.0\n\nMade with ❤️ for young readers'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}