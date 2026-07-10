import 'package:flutter/material.dart';

import '../../data/device_state.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../therapy/treatment_selection_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.onGoToDevice});

  final VoidCallback onGoToDevice;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            // Header ---------------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning,',
                        style: text.bodyMedium?.copyWith(color: AppColors.slate),
                      ),
                      Text(
                        'Ibrahim',
                        style: text.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                IconButton.outlined(
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    side: const BorderSide(color: AppColors.line),
                  ),
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.tealSoft,
                  child: Text(
                    'IB',
                    style: TextStyle(
                      color: AppColors.teal,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Device status ---------------------------------------------------
            ValueListenableBuilder<bool>(
              valueListenable: DeviceState.connected,
              builder: (context, connected, _) => AppCard(
                onTap: onGoToDevice,
                child: Row(
                  children: [
                    IconBadge(
                      icon: connected
                          ? Icons.bluetooth_connected_rounded
                          : Icons.bluetooth_disabled_rounded,
                      color: connected ? AppColors.teal : AppColors.muted,
                      background:
                          connected ? AppColors.tealSoft : AppColors.bg,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            connected
                                ? DeviceState.deviceName
                                : 'No device connected',
                            style: text.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            connected
                                ? '2 wraps attached · Battery ${DeviceState.batteryPct}%'
                                : 'Tap to pair your IGNITE control unit',
                            style: text.bodySmall
                                ?.copyWith(color: AppColors.slate),
                          ),
                        ],
                      ),
                    ),
                    StatusChip(
                      label: connected ? 'CONNECTED' : 'PAIR',
                      icon: connected
                          ? Icons.check_circle_rounded
                          : Icons.add_rounded,
                      color: connected ? AppColors.success : AppColors.ember,
                      background: connected
                          ? AppColors.successSoft
                          : AppColors.emberSoft,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Start therapy hero ---------------------------------------------
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TreatmentSelectionScreen(),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.emberGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.ember.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Therapy',
                              style: text.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Heat + vibration · up to 4 wraps in one cycle',
                              style: text.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Today stats -----------------------------------------------------
            const SectionHeader(title: "Today's recovery"),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: Icons.local_fire_department_rounded,
                    value: '2',
                    label: 'Sessions',
                    color: AppColors.ember,
                    background: AppColors.emberSoft,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    icon: Icons.schedule_rounded,
                    value: '50m',
                    label: 'Therapy time',
                    color: AppColors.teal,
                    background: AppColors.tealSoft,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    icon: Icons.bolt_rounded,
                    value: '5',
                    label: 'Day streak',
                    color: AppColors.warning,
                    background: AppColors.warningSoft,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Weekly chart ----------------------------------------------------
            const SectionHeader(title: 'This week'),
            const SizedBox(height: 12),
            const AppCard(child: _WeeklyChart()),
            const SizedBox(height: 24),

            // Recent sessions -------------------------------------------------
            const SectionHeader(title: 'Recent sessions'),
            const SizedBox(height: 12),
            ...mockHistory.take(3).map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SessionTile(record: s),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(icon: icon, color: color, background: background, size: 36),
          const SizedBox(height: 12),
          Text(
            value,
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: text.labelSmall?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart();

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    const maxMinutes = 60.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Therapy minutes',
                style: text.bodySmall?.copyWith(color: AppColors.slate),
              ),
            ),
            Text(
              '185 min total',
              style: text.labelMedium?.copyWith(
                color: AppColors.ember,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < weeklyMinutes.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: (weeklyMinutes[i] / maxMinutes) * 80 + 4,
                        decoration: BoxDecoration(
                          color: weeklyMinutes[i] == 0
                              ? AppColors.line
                              : (i == 5
                                  ? AppColors.ember
                                  : AppColors.ember.withValues(alpha: 0.35)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _days[i],
                        style: text.labelSmall
                            ?.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Shared session list tile (dashboard + history).
class SessionTile extends StatelessWidget {
  const SessionTile({super.key, required this.record});

  final SessionRecord record;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isSport = record.mode == TherapyMode.sport;
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          IconBadge(
            icon: isSport
                ? Icons.directions_run_rounded
                : Icons.healing_rounded,
            color: isSport ? AppColors.ember : AppColors.teal,
            background: isSport ? AppColors.emberSoft : AppColors.tealSoft,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.program,
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.dayLabel} · ${record.time} · ${record.wrapCount} '
                  'wrap${record.wrapCount > 1 ? 's' : ''}',
                  style: text.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${record.minutes} min',
                style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(
                '${record.avgTemp.toStringAsFixed(1)}°C avg',
                style: text.labelSmall?.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
