import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'session_running_screen.dart';

class SessionSetupScreen extends StatefulWidget {
  const SessionSetupScreen({super.key, required this.program});

  final TherapyProgram program;

  @override
  State<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends State<SessionSetupScreen> {
  late List<WrapConfig> _wraps;
  late int _minutes;

  static const _durations = [10, 15, 20, 30];

  @override
  void initState() {
    super.initState();
    _wraps = widget.program.wraps.map((w) => w.copy()).toList();
    _minutes = widget.program.minutes;
  }

  void _addWrap() {
    if (_wraps.length >= 4) return;
    final used = _wraps.map((w) => w.area).toSet();
    final next = BodyArea.values.firstWhere(
      (a) => !used.contains(a),
      orElse: () => BodyArea.lowerBack,
    );
    setState(() => _wraps.add(WrapConfig(area: next)));
  }

  void _startSession() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SessionRunningScreen(
          programName: widget.program.name,
          wraps: _wraps,
          minutes: _minutes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(widget.program.name)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Therapy wraps',
                          style: text.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      StatusChip(
                        label: '${_wraps.length} / 4',
                        color: _wraps.length == 4
                            ? AppColors.warning
                            : AppColors.teal,
                        background: _wraps.length == 4
                            ? AppColors.warningSoft
                            : AppColors.tealSoft,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Configure each wrap — body area, heat and vibration.',
                    style: text.bodySmall?.copyWith(color: AppColors.slate),
                  ),
                  const SizedBox(height: 14),
                  for (var i = 0; i < _wraps.length; i++) ...[
                    _WrapConfigCard(
                      index: i,
                      config: _wraps[i],
                      canRemove: _wraps.length > 1,
                      onChanged: () => setState(() {}),
                      onRemove: () => setState(() => _wraps.removeAt(i)),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_wraps.length < 4)
                    OutlinedButton.icon(
                      onPressed: _addWrap,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add Wrap'),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'Session duration',
                    style: text.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      for (final d in _durations) ...[
                        Expanded(
                          child: _DurationChip(
                            minutes: d,
                            selected: _minutes == d,
                            onTap: () => setState(() => _minutes = d),
                          ),
                        ),
                        if (d != _durations.last) const SizedBox(width: 10),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  AppCard(
                    color: AppColors.tealSoft,
                    borderColor: AppColors.tealSoft,
                    child: Row(
                      children: [
                        const Icon(Icons.shield_rounded,
                            color: AppColors.teal, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Overheat shutdown, low-battery cutoff and session '
                            'timeout protection are always on.',
                            style: text.bodySmall?.copyWith(
                              color: const Color(0xFF0B6E73),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom summary + start
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      _summaryItem(text, Icons.schedule_rounded, '$_minutes min'),
                      const SizedBox(width: 16),
                      _summaryItem(
                          text, Icons.grid_view_rounded, '${_wraps.length} wraps'),
                      const SizedBox(width: 16),
                      _summaryItem(
                        text,
                        Icons.battery_5_bar_rounded,
                        '~${(_minutes * _wraps.length * 0.35).round()}% battery',
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: _startSession,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Start Session'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(TextTheme text, IconData icon, String label) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.slate),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: text.labelMedium?.copyWith(
                color: AppColors.slate,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({
    required this.minutes,
    required this.selected,
    required this.onTap,
  });

  final int minutes;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.ember : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.ember : AppColors.line,
            ),
          ),
          child: Column(
            children: [
              Text(
                '$minutes',
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : AppColors.ink,
                ),
              ),
              Text(
                'min',
                style: text.labelSmall?.copyWith(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.85)
                      : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WrapConfigCard extends StatelessWidget {
  const _WrapConfigCard({
    required this.index,
    required this.config,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  final int index;
  final WrapConfig config;
  final bool canRemove;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final letter = String.fromCharCode(65 + index);
    final tempT = (config.targetTemp - 35) / 10;
    final heatColor = AppColors.heat(tempT);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.emberSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'WRAP $letter',
                  style: text.labelSmall?.copyWith(
                    color: AppColors.emberDeep,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              if (canRemove)
                IconButton(
                  onPressed: onRemove,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.muted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Body area chips
          Text(
            'Body area',
            style: text.labelMedium?.copyWith(
              color: AppColors.slate,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final area in BodyArea.values)
                ChoiceChip(
                  label: Text(area.label),
                  avatar: Icon(
                    area.icon,
                    size: 16,
                    color: config.area == area
                        ? AppColors.emberDeep
                        : AppColors.slate,
                  ),
                  selected: config.area == area,
                  showCheckmark: false,
                  selectedColor: AppColors.emberSoft,
                  backgroundColor: AppColors.bg,
                  labelStyle: text.labelMedium?.copyWith(
                    color: config.area == area
                        ? AppColors.emberDeep
                        : AppColors.slate,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                    color: config.area == area
                        ? AppColors.ember
                        : AppColors.line,
                  ),
                  onSelected: (_) {
                    config.area = area;
                    onChanged();
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Heat slider
          Row(
            children: [
              Expanded(
                child: Text(
                  'Heat level',
                  style: text.labelMedium?.copyWith(
                    color: AppColors.slate,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: heatColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${config.targetTemp.toInt()}°C',
                  style: text.labelMedium?.copyWith(
                    color: heatColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: heatColor,
              thumbColor: heatColor,
              inactiveTrackColor: AppColors.line,
              overlayColor: heatColor.withValues(alpha: 0.12),
              trackHeight: 5,
            ),
            child: Slider(
              value: config.targetTemp,
              min: 35,
              max: 45,
              divisions: 10,
              onChanged: (v) {
                config.targetTemp = v;
                onChanged();
              },
            ),
          ),

          // Vibration
          Text(
            'Vibration',
            style: text.labelMedium?.copyWith(
              color: AppColors.slate,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<VibrationLevel>(
              segments: [
                for (final v in VibrationLevel.values)
                  ButtonSegment(value: v, label: Text(v.label)),
              ],
              selected: {config.vibration},
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: AppColors.emberSoft,
                selectedForegroundColor: AppColors.emberDeep,
                foregroundColor: AppColors.slate,
                side: const BorderSide(color: AppColors.line),
                textStyle:
                    text.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              onSelectionChanged: (s) {
                config.vibration = s.first;
                onChanged();
              },
            ),
          ),
        ],
      ),
    );
  }
}
