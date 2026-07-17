import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'auth/sign_in_screen.dart';
import 'auth/sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              const Center(child: AnimatedIgniteLogo(height: 200)),
              const SizedBox(height: 16),
              Text(
                'Smart recovery, wherever it hurts.',
                textAlign: TextAlign.center,
                style: text.titleMedium?.copyWith(
                  color: AppColors.slate,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 36),
              const _FeatureRow(
                icon: Icons.thermostat_rounded,
                title: 'Precision heat therapy',
                subtitle: 'Controlled 35–45°C with overheat protection',
              ),
              const SizedBox(height: 14),
              const _FeatureRow(
                icon: Icons.vibration_rounded,
                title: 'Deep vibration relief',
                subtitle: 'Three intensity levels for every recovery stage',
              ),
              const SizedBox(height: 14),
              const _FeatureRow(
                icon: Icons.grid_view_rounded,
                title: 'Up to 4 wraps, one cycle',
                subtitle: 'Interchangeable wraps for full-body treatment',
              ),
              const Spacer(flex: 3),
              FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                ),
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                ),
                child: const Text('I already have an account'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        IconBadge(icon: icon),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: text.bodySmall?.copyWith(color: AppColors.slate),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
