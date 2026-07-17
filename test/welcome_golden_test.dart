import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ignite_mockup/screens/welcome_screen.dart';

void main() {
  testWidgets('welcome renders logo (golden)', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
    await tester.runAsync(() async {
      final ctx = tester.element(find.byType(WelcomeScreen));
      for (var i = 1; i <= 10; i++) {
        await precacheImage(
          AssetImage(
              'assets/images/frames/frame_${i.toString().padLeft(2, '0')}.png'),
          ctx,
        );
      }
    });
    await tester.pump();
    await expectLater(
      find.byType(WelcomeScreen),
      matchesGoldenFile('goldens/welcome.png'),
    );
  });
}
