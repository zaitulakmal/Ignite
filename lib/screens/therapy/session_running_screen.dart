import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../theme/app_theme.dart';
import 'session_complete_screen.dart';

class SessionRunningScreen extends StatefulWidget {
  const SessionRunningScreen({
    super.key,
    required this.programName,
    required this.wraps,
    required this.minutes,
  });

  final String programName;
  final List<WrapConfig> wraps;
  final int minutes;

  @override
  State<SessionRunningScreen> createState() => _SessionRunningScreenState();
}

class _SessionRunningScreenState extends State<SessionRunningScreen> {
  late int _remaining; // seconds
  late List<double> _currentTemps;
  Timer? _ticker;
  bool _paused = false;
  int _tick = 0;

  int get _total => widget.minutes * 60;

  @override
  void initState() {
    super.initState();
    _remaining = _total;
    _currentTemps = widget.wraps.map((_) => 33.0).toList();
    _ticker = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _onTick(Timer t) {
    if (_paused) return;
    setState(() {
      _tick++;
      if (_remaining > 0) _remaining--;
      for (var i = 0; i < _currentTemps.length; i++) {
        final target = widget.wraps[i].targetTemp;
        final diff = target - _currentTemps[i];
        // Ramp toward target, then hold with a gentle sensor jitter.
        if (diff.abs() > 0.3) {
          _currentTemps[i] += diff * 0.12;
        } else {
          _currentTemps[i] =
              target + math.sin((_tick + i * 7) / 3) * 0.2;
        }
      }
    });
    if (_remaining <= 0) _finish(completed: true);
  }

  void _finish({required bool completed}) {
    _ticker?.cancel();
    final elapsed = _total - _remaining;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SessionCompleteScreen(
          programName: widget.programName,
          minutes: (elapsed / 60).ceil().clamp(1, widget.minutes),
          wrapCount: widget.wraps.length,
          avgTemp: widget.wraps
                  .map((w) => w.targetTemp)
                  .reduce((a, b) => a + b) /
              widget.wraps.length,
          completed: completed,
        ),
      ),
    );
  }

  Future<void> _confirmStop() async {
    final stop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('End session early?'),
        content: const Text(
          'The wraps will cool down safely and your progress will be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep Going'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              minimumSize: const Size(0, 44),
            ),
            child: const Text('End Session'),
          ),
        ],
      ),
    );
    if (stop == true && mounted) _finish(completed: false);
  }

  String _fmt(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (_remaining / _total);
    return Theme(
      data: AppTheme.sessionDark(),
      child: Builder(
        builder: (context) {
          final text = Theme.of(context).textTheme;
          return Scaffold(
            backgroundColor: AppColors.darkBg,
            appBar: AppBar(
              backgroundColor: AppColors.darkBg,
              foregroundColor: AppColors.darkText,
              automaticallyImplyLeading: false,
              title: Text(
                widget.programName,
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.shield_rounded,
                      color: AppColors.success, size: 20),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _statusRow(text),
                  const Spacer(),
                  // Timer ring
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: CustomPaint(
                            painter: _RingPainter(
                              progress: progress,
                              trackColor: AppColors.darkLine,
                              glow: !_paused,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _fmt(_remaining),
                              style: text.displayMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _paused
                                  ? 'PAUSED'
                                  : 'of ${widget.minutes}:00 remaining',
                              style: text.labelMedium?.copyWith(
                                color: _paused
                                    ? AppColors.warning
                                    : AppColors.darkMuted,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Live wrap tiles
                  SizedBox(
                    height: 128,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.wraps.length,
                      separatorBuilder: (_, i) => const SizedBox(width: 10),
                      itemBuilder: (context, i) =>
                          _wrapTile(text, i, widget.wraps[i]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Controls
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _confirmStop,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: BorderSide(
                                color: AppColors.danger.withValues(alpha: 0.5),
                              ),
                              minimumSize: const Size.fromHeight(56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.stop_rounded),
                            label: const Text('Stop'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: FilledButton.icon(
                            onPressed: () =>
                                setState(() => _paused = !_paused),
                            style: FilledButton.styleFrom(
                              backgroundColor: _paused
                                  ? AppColors.success
                                  : AppColors.ember,
                              minimumSize: const Size.fromHeight(56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: Icon(_paused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded),
                            label: Text(_paused ? 'Resume' : 'Pause'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statusRow(TextTheme text) {
    Widget item(IconData icon, String label, Color color) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: text.labelSmall?.copyWith(
                color: AppColors.darkMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkLine),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          item(Icons.bluetooth_connected_rounded, 'Connected', AppColors.teal),
          item(Icons.battery_5_bar_rounded, 'Battery 82%', AppColors.success),
          item(Icons.shield_rounded, 'Safety OK', AppColors.success),
        ],
      ),
    );
  }

  Widget _wrapTile(TextTheme text, int i, WrapConfig wrap) {
    final letter = String.fromCharCode(65 + i);
    final temp = _currentTemps[i];
    final tempT = ((temp - 35) / 10).clamp(0.0, 1.0);
    final heatColor = AppColors.heat(tempT);
    final atTarget = (temp - wrap.targetTemp).abs() < 0.5;

    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.darkLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'WRAP $letter',
                style: text.labelSmall?.copyWith(
                  color: AppColors.darkMuted,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
              const Spacer(),
              if (wrap.vibration != VibrationLevel.off)
                const Icon(Icons.vibration_rounded,
                    size: 14, color: AppColors.teal),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            wrap.area.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${temp.toStringAsFixed(1)}°',
                style: text.headlineSmall?.copyWith(
                  color: heatColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  '/ ${wrap.targetTemp.toInt()}°',
                  style: text.labelSmall?.copyWith(color: AppColors.darkMuted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: atTarget ? 1 : tempT,
              minHeight: 4,
              backgroundColor: AppColors.darkLine,
              color: heatColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.glow,
  });

  final double progress;
  final Color trackColor;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = 2 * math.pi * progress;

    if (glow) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round
        ..color = AppColors.ember.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawArc(rect, -math.pi / 2, sweep, false, glowPaint);
    }

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [Color(0xFFFF8A3C), AppColors.ember, AppColors.emberDeep],
        transform: GradientRotation(-math.pi / 2),
      ).createShader(rect);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.glow != glow;
}
