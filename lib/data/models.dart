import 'package:flutter/material.dart';

enum TherapyMode { sport, medical }

extension TherapyModeX on TherapyMode {
  String get label => this == TherapyMode.sport ? 'Sport Therapy' : 'Medical Therapy';
}

enum BodyArea { shoulder, lowerBack, knee, thigh, calf, wrist }

extension BodyAreaX on BodyArea {
  String get label => switch (this) {
        BodyArea.shoulder => 'Shoulder',
        BodyArea.lowerBack => 'Lower Back',
        BodyArea.knee => 'Knee',
        BodyArea.thigh => 'Thigh',
        BodyArea.calf => 'Calf',
        BodyArea.wrist => 'Wrist',
      };

  IconData get icon => switch (this) {
        BodyArea.shoulder => Icons.accessibility_new_rounded,
        BodyArea.lowerBack => Icons.airline_seat_recline_normal_rounded,
        BodyArea.knee => Icons.directions_walk_rounded,
        BodyArea.thigh => Icons.directions_run_rounded,
        BodyArea.calf => Icons.hiking_rounded,
        BodyArea.wrist => Icons.front_hand_rounded,
      };
}

enum VibrationLevel { off, low, medium, high }

extension VibrationLevelX on VibrationLevel {
  String get label => switch (this) {
        VibrationLevel.off => 'Off',
        VibrationLevel.low => 'Low',
        VibrationLevel.medium => 'Med',
        VibrationLevel.high => 'High',
      };
}

/// Configuration for a single therapy wrap in a session (max 4 per cycle).
class WrapConfig {
  WrapConfig({
    required this.area,
    this.targetTemp = 40,
    this.vibration = VibrationLevel.low,
  });

  BodyArea area;
  double targetTemp; // 35–45 °C
  VibrationLevel vibration;

  WrapConfig copy() =>
      WrapConfig(area: area, targetTemp: targetTemp, vibration: vibration);
}

class TherapyProgram {
  const TherapyProgram({
    required this.name,
    required this.mode,
    required this.description,
    required this.minutes,
    required this.wraps,
    this.isCustom = false,
  });

  final String name;
  final TherapyMode mode;
  final String description;
  final int minutes;
  final List<WrapConfig> wraps;
  final bool isCustom;
}

class SessionRecord {
  const SessionRecord({
    required this.program,
    required this.mode,
    required this.dayLabel,
    required this.time,
    required this.minutes,
    required this.wrapCount,
    required this.avgTemp,
  });

  final String program;
  final TherapyMode mode;
  final String dayLabel;
  final String time;
  final int minutes;
  final int wrapCount;
  final double avgTemp;
}

// ---------------------------------------------------------------------------
// Mock data
// ---------------------------------------------------------------------------

final sportPrograms = <TherapyProgram>[
  TherapyProgram(
    name: 'Post-Workout Recovery',
    mode: TherapyMode.sport,
    description: 'Flush out fatigue after training with deep heat + wave vibration.',
    minutes: 20,
    wraps: [
      WrapConfig(area: BodyArea.thigh, targetTemp: 42, vibration: VibrationLevel.medium),
      WrapConfig(area: BodyArea.calf, targetTemp: 41, vibration: VibrationLevel.medium),
    ],
  ),
  TherapyProgram(
    name: 'Pre-Training Warm-Up',
    mode: TherapyMode.sport,
    description: 'Prime muscles before activity with a short ramp-up cycle.',
    minutes: 10,
    wraps: [
      WrapConfig(area: BodyArea.thigh, targetTemp: 39, vibration: VibrationLevel.low),
    ],
  ),
  TherapyProgram(
    name: 'DOMS Relief',
    mode: TherapyMode.sport,
    description: 'Ease delayed-onset soreness with steady mid-range heat.',
    minutes: 30,
    wraps: [
      WrapConfig(area: BodyArea.thigh, targetTemp: 40, vibration: VibrationLevel.low),
      WrapConfig(area: BodyArea.calf, targetTemp: 40, vibration: VibrationLevel.low),
      WrapConfig(area: BodyArea.lowerBack, targetTemp: 41, vibration: VibrationLevel.off),
    ],
  ),
];

final medicalPrograms = <TherapyProgram>[
  TherapyProgram(
    name: 'Lower Back Relief',
    mode: TherapyMode.medical,
    description: 'Gentle sustained heat for chronic lower back discomfort.',
    minutes: 30,
    wraps: [
      WrapConfig(area: BodyArea.lowerBack, targetTemp: 41, vibration: VibrationLevel.low),
    ],
  ),
  TherapyProgram(
    name: 'Knee Rehabilitation',
    mode: TherapyMode.medical,
    description: 'Post-injury circulation support with low vibration.',
    minutes: 20,
    wraps: [
      WrapConfig(area: BodyArea.knee, targetTemp: 40, vibration: VibrationLevel.low),
    ],
  ),
  TherapyProgram(
    name: 'Shoulder Stiffness',
    mode: TherapyMode.medical,
    description: 'Loosen stiff shoulders and improve range of motion.',
    minutes: 15,
    wraps: [
      WrapConfig(area: BodyArea.shoulder, targetTemp: 42, vibration: VibrationLevel.medium),
    ],
  ),
];

TherapyProgram customProgram(TherapyMode mode) => TherapyProgram(
      name: 'Custom Session',
      mode: mode,
      description: 'Build your own cycle — up to 4 wraps, your rules.',
      minutes: 20,
      wraps: [WrapConfig(area: BodyArea.lowerBack)],
      isCustom: true,
    );

final mockHistory = <SessionRecord>[
  const SessionRecord(
    program: 'Post-Workout Recovery',
    mode: TherapyMode.sport,
    dayLabel: 'Today',
    time: '7:42 AM',
    minutes: 20,
    wrapCount: 2,
    avgTemp: 41.6,
  ),
  const SessionRecord(
    program: 'Lower Back Relief',
    mode: TherapyMode.medical,
    dayLabel: 'Yesterday',
    time: '9:15 PM',
    minutes: 30,
    wrapCount: 1,
    avgTemp: 40.8,
  ),
  const SessionRecord(
    program: 'DOMS Relief',
    mode: TherapyMode.sport,
    dayLabel: 'Yesterday',
    time: '6:30 AM',
    minutes: 30,
    wrapCount: 3,
    avgTemp: 40.2,
  ),
  const SessionRecord(
    program: 'Knee Rehabilitation',
    mode: TherapyMode.medical,
    dayLabel: 'Mon, 6 Jul',
    time: '8:05 PM',
    minutes: 20,
    wrapCount: 1,
    avgTemp: 39.9,
  ),
  const SessionRecord(
    program: 'Shoulder Stiffness',
    mode: TherapyMode.medical,
    dayLabel: 'Sun, 5 Jul',
    time: '10:20 AM',
    minutes: 15,
    wrapCount: 1,
    avgTemp: 41.9,
  ),
];

/// Weekly activity minutes for the dashboard chart (Mon..Sun).
const weeklyMinutes = [20, 50, 0, 30, 20, 45, 20];
