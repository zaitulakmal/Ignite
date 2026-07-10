import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../dashboard/dashboard_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    // Group records by day label, preserving order.
    final groups = <String, List<SessionRecord>>{};
    for (final r in mockHistory) {
      groups.putIfAbsent(r.dayLabel, () => []).add(r);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Therapy History')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            // Week summary
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _summary(text, '5', 'Sessions\nthis week'),
                  Container(width: 1, height: 44, color: AppColors.line),
                  _summary(text, '1h 55m', 'Total\ntherapy time'),
                  Container(width: 1, height: 44, color: AppColors.line),
                  _summary(text, '40.9°C', 'Average\nheat'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            for (final entry in groups.entries) ...[
              Text(
                entry.key,
                style: text.labelLarge?.copyWith(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),
              ...entry.value.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SessionTile(record: r),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _summary(TextTheme text, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: text.labelSmall?.copyWith(
              color: AppColors.slate,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
