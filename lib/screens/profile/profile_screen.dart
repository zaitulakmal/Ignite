import 'package:flutter/material.dart';

import '../../data/device_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;

  void _signOut() {
    DeviceState.connected.value = false;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            // Identity card
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.tealSoft,
                    child: Text(
                      'IB',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ibrahim Hakim',
                          style: text.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'ibrahim@example.com',
                          style:
                              text.bodySmall?.copyWith(color: AppColors.slate),
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          children: [
                            StatusChip(
                              label: '172 cm',
                              color: AppColors.slate,
                              background: AppColors.bg,
                            ),
                            SizedBox(width: 6),
                            StatusChip(
                              label: '68 kg',
                              color: AppColors.slate,
                              background: AppColors.bg,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined,
                        color: AppColors.slate),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const SectionHeader(title: 'Preferences'),
            const SizedBox(height: 12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    value: _notifications,
                    onChanged: (v) => setState(() => _notifications = v),
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.ember,
                    secondary: const Icon(Icons.notifications_none_rounded,
                        color: AppColors.slate),
                    title: Text(
                      'Session reminders',
                      style:
                          text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Divider(height: 1),
                  _row(Icons.language_rounded, 'Language', trailing: 'English'),
                  const Divider(height: 1),
                  _row(Icons.straighten_rounded, 'Units', trailing: 'Metric'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const SectionHeader(title: 'Device & safety'),
            const SizedBox(height: 12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _row(Icons.sensors_rounded, 'My device',
                      trailing: DeviceState.deviceName),
                  const Divider(height: 1),
                  _row(Icons.shield_outlined, 'Safety information'),
                  const Divider(height: 1),
                  _row(Icons.help_outline_rounded, 'Help & support'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            OutlinedButton.icon(
              onPressed: _signOut,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: const BorderSide(color: AppColors.line),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign Out'),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'iGnite v0.1.0 · MeDREV Smart Recovery',
                style: text.labelSmall?.copyWith(color: AppColors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String title, {String? trailing}) {
    final text = Theme.of(context).textTheme;
    return ListTile(
      onTap: () {},
      leading: Icon(icon, color: AppColors.slate),
      title: Text(
        title,
        style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: text.bodySmall?.copyWith(color: AppColors.muted),
            ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}
