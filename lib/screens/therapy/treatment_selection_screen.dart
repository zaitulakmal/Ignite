import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'session_setup_screen.dart';

class TreatmentSelectionScreen extends StatefulWidget {
  const TreatmentSelectionScreen({super.key});

  @override
  State<TreatmentSelectionScreen> createState() =>
      _TreatmentSelectionScreenState();
}

class _TreatmentSelectionScreenState extends State<TreatmentSelectionScreen> {
  TherapyMode _mode = TherapyMode.sport;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final programs =
        _mode == TherapyMode.sport ? sportPrograms : medicalPrograms;
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Treatment')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              'What are you recovering from today?',
              style: text.bodyLarge?.copyWith(color: AppColors.slate),
            ),
            const SizedBox(height: 16),

            // Mode cards
            Row(
              children: [
                Expanded(
                  child: _ModeCard(
                    icon: Icons.directions_run_rounded,
                    title: 'Sport\nTherapy',
                    subtitle: 'Warm-up & recovery',
                    selected: _mode == TherapyMode.sport,
                    accent: AppColors.ember,
                    accentSoft: AppColors.emberSoft,
                    onTap: () => setState(() => _mode = TherapyMode.sport),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ModeCard(
                    icon: Icons.healing_rounded,
                    title: 'Medical\nTherapy',
                    subtitle: 'Pain relief & rehab',
                    selected: _mode == TherapyMode.medical,
                    accent: AppColors.teal,
                    accentSoft: AppColors.tealSoft,
                    onTap: () => setState(() => _mode = TherapyMode.medical),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SectionHeader(
              title: _mode == TherapyMode.sport
                  ? 'Sport programs'
                  : 'Medical programs',
            ),
            const SizedBox(height: 12),
            ...programs.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ProgramCard(
                  program: p,
                  onTap: () => _openSetup(p),
                ),
              ),
            ),

            // Custom session
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _openSetup(customProgram(_mode)),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.ember.withValues(alpha: 0.5),
                      width: 1.4,
                    ),
                    color: AppColors.emberSoft.withValues(alpha: 0.5),
                  ),
                  child: Row(
                    children: [
                      const IconBadge(icon: Icons.tune_rounded),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Custom Session',
                              style: text.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Build your own — up to 4 wraps, your rules',
                              style: text.bodySmall
                                  ?.copyWith(color: AppColors.slate),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.ember),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSetup(TherapyProgram program) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SessionSetupScreen(program: program)),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.accent,
    required this.accentSoft,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final Color accent;
  final Color accentSoft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? accentSoft : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? accent : AppColors.line,
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBadge(
                    icon: icon,
                    color: selected ? accent : AppColors.slate,
                    background:
                        selected ? Colors.white : AppColors.bg,
                  ),
                  const Spacer(),
                  if (selected)
                    Icon(Icons.check_circle_rounded, color: accent, size: 22),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: text.labelSmall?.copyWith(color: AppColors.slate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.program, required this.onTap});

  final TherapyProgram program;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  program.name,
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            program.description,
            style: text.bodySmall?.copyWith(color: AppColors.slate),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              StatusChip(
                label: '${program.minutes} MIN',
                icon: Icons.schedule_rounded,
                color: AppColors.slate,
                background: AppColors.bg,
              ),
              const SizedBox(width: 8),
              StatusChip(
                label:
                    '${program.wraps.length} WRAP${program.wraps.length > 1 ? 'S' : ''}',
                icon: Icons.grid_view_rounded,
                color: AppColors.slate,
                background: AppColors.bg,
              ),
              const SizedBox(width: 8),
              StatusChip(
                label:
                    '${program.wraps.map((w) => w.targetTemp).reduce((a, b) => a > b ? a : b).toInt()}°C',
                icon: Icons.thermostat_rounded,
                color: AppColors.emberDeep,
                background: AppColors.emberSoft,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
