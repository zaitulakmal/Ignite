import 'package:flutter/material.dart';

import 'data/device_state.dart';
import 'data/models.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/shell/home_shell.dart';
import 'screens/therapy/session_complete_screen.dart';
import 'screens/therapy/session_running_screen.dart';
import 'screens/therapy/session_setup_screen.dart';
import 'screens/therapy/treatment_selection_screen.dart';
import 'screens/welcome_screen.dart';

/// Deep-link routes so every screen is reachable by URL
/// (used for demos and automated screenshots).
final Map<String, WidgetBuilder> demoRoutes = {
  '/': (_) => const WelcomeScreen(),
  '/signin': (_) => const SignInScreen(),
  '/signup': (_) => const SignUpScreen(),
  '/forgot': (_) => const ForgotPasswordScreen(),
  '/home': (_) => const HomeShell(),
  '/history': (_) => const HomeShell(initialIndex: 1),
  '/device-pairing': (_) => const HomeShell(initialIndex: 2),
  '/device-connected': (_) => const _ConnectedDeviceDemo(),
  '/profile': (_) => const HomeShell(initialIndex: 3),
  '/treatment': (_) => const TreatmentSelectionScreen(),
  '/setup': (_) => SessionSetupScreen(program: sportPrograms.first),
  '/session': (_) => SessionRunningScreen(
        programName: 'Post-Workout Recovery',
        minutes: 20,
        wraps: [
          WrapConfig(
              area: BodyArea.thigh,
              targetTemp: 42,
              vibration: VibrationLevel.medium),
          WrapConfig(
              area: BodyArea.calf,
              targetTemp: 41,
              vibration: VibrationLevel.medium),
          WrapConfig(
              area: BodyArea.lowerBack,
              targetTemp: 40,
              vibration: VibrationLevel.off),
        ],
      ),
  '/complete': (_) => const SessionCompleteScreen(
        programName: 'Post-Workout Recovery',
        minutes: 20,
        wrapCount: 3,
        avgTemp: 41.0,
        completed: true,
      ),
};

class _ConnectedDeviceDemo extends StatefulWidget {
  const _ConnectedDeviceDemo();

  @override
  State<_ConnectedDeviceDemo> createState() => _ConnectedDeviceDemoState();
}

class _ConnectedDeviceDemoState extends State<_ConnectedDeviceDemo> {
  @override
  void initState() {
    super.initState();
    DeviceState.connected.value = true;
  }

  @override
  Widget build(BuildContext context) => const HomeShell(initialIndex: 2);
}
