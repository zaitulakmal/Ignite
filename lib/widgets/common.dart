import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Brand mark: official iGnite logo (medical cross + flame).
class IgniteLogo extends StatelessWidget {
  const IgniteLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_mark.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}

/// Full iGnite logo (mark + wordmark) with a looping flame-flicker animation
/// built from the 10 official brand frames.
class AnimatedIgniteLogo extends StatefulWidget {
  const AnimatedIgniteLogo({super.key, this.height = 180});

  final double height;

  @override
  State<AnimatedIgniteLogo> createState() => _AnimatedIgniteLogoState();
}

class _AnimatedIgniteLogoState extends State<AnimatedIgniteLogo> {
  static const _frameCount = 10;
  int _frame = 0;
  Timer? _timer;
  bool _precached = false;

  String _asset(int i) =>
      'assets/images/frames/frame_${(i + 1).toString().padLeft(2, '0')}.png';

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 110), (_) {
      if (mounted) setState(() => _frame = (_frame + 1) % _frameCount);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precached) {
      _precached = true;
      for (var i = 0; i < _frameCount; i++) {
        precacheImage(AssetImage(_asset(i)), context);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _asset(_frame),
      height: widget.height,
      fit: BoxFit.contain,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    required this.background,
    this.icon,
  });

  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
          ),
        ],
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color = AppColors.surface,
    this.borderColor = AppColors.line,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: card,
      ),
    );
  }
}

class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.slate,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    this.color = AppColors.ember,
    this.background = AppColors.emberSoft,
    this.size = 44,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}
