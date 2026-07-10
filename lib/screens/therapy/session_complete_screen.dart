import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class SessionCompleteScreen extends StatefulWidget {
  const SessionCompleteScreen({
    super.key,
    required this.programName,
    required this.minutes,
    required this.wrapCount,
    required this.avgTemp,
    required this.completed,
  });

  final String programName;
  final int minutes;
  final int wrapCount;
  final double avgTemp;
  final bool completed;

  @override
  State<SessionCompleteScreen> createState() => _SessionCompleteScreenState();
}

class _SessionCompleteScreenState extends State<SessionCompleteScreen> {
  int? _feeling;

  static const _feelings = ['Much better', 'Better', 'Same', 'Worse'];

  void _save() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session saved to your history')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              IconBadge(
                icon: widget.completed
                    ? Icons.check_rounded
                    : Icons.flag_rounded,
                size: 84,
                color: Colors.white,
                background:
                    widget.completed ? AppColors.success : AppColors.warning,
              ),
              const SizedBox(height: 24),
              Text(
                widget.completed ? 'Session Complete' : 'Session Ended',
                textAlign: TextAlign.center,
                style:
                    text.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                widget.programName,
                textAlign: TextAlign.center,
                style: text.bodyLarge?.copyWith(color: AppColors.slate),
              ),
              const SizedBox(height: 28),
              AppCard(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    _stat(text, '${widget.minutes}', 'minutes'),
                    _divider(),
                    _stat(text, '${widget.wrapCount}', 'wraps'),
                    _divider(),
                    _stat(
                        text, '${widget.avgTemp.toStringAsFixed(1)}°', 'avg heat'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'How does your body feel?',
                textAlign: TextAlign.center,
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < _feelings.length; i++)
                    ChoiceChip(
                      label: Text(_feelings[i]),
                      selected: _feeling == i,
                      showCheckmark: false,
                      selectedColor: AppColors.emberSoft,
                      backgroundColor: AppColors.surface,
                      labelStyle: text.labelLarge?.copyWith(
                        color: _feeling == i
                            ? AppColors.emberDeep
                            : AppColors.slate,
                        fontWeight: FontWeight.w700,
                      ),
                      side: BorderSide(
                        color:
                            _feeling == i ? AppColors.ember : AppColors.line,
                      ),
                      onSelected: (_) => setState(() => _feeling = i),
                    ),
                ],
              ),
              const Spacer(),
              FilledButton(
                onPressed: _save,
                child: const Text('Save & Done'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(TextTheme text, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: text.labelSmall?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 36, color: AppColors.line);
}
