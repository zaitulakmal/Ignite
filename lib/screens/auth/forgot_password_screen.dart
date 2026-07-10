import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(backgroundColor: AppColors.surface),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _sent ? _buildSent(text) : _buildForm(text),
        ),
      ),
    );
  }

  Widget _buildForm(TextTheme text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const IconBadge(
          icon: Icons.lock_reset_rounded,
          size: 56,
          color: AppColors.teal,
          background: AppColors.tealSoft,
        ),
        const SizedBox(height: 20),
        Text(
          'Reset your password',
          style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          "Enter the email linked to your account and we'll send a reset link.",
          style: text.bodyLarge?.copyWith(color: AppColors.slate),
        ),
        const SizedBox(height: 28),
        const LabeledField(
          label: 'Email',
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => setState(() => _sent = true),
          child: const Text('Send Reset Link'),
        ),
      ],
    );
  }

  Widget _buildSent(TextTheme text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const IconBadge(
          icon: Icons.mark_email_read_rounded,
          size: 64,
          color: AppColors.success,
          background: AppColors.successSoft,
        ),
        const SizedBox(height: 20),
        Text(
          'Check your inbox',
          textAlign: TextAlign.center,
          style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'We sent a password reset link to your email. It expires in 30 minutes.',
          textAlign: TextAlign.center,
          style: text.bodyLarge?.copyWith(color: AppColors.slate),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back to Sign In'),
        ),
      ],
    );
  }
}
