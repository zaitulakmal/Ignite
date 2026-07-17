import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ignite_mockup/widgets/common.dart';

void main() {
  testWidgets('logo mark asset decodes', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: IgniteLogo(size: 96)));
    await tester.runAsync(() async {
      final context = tester.element(find.byType(IgniteLogo));
      await precacheImage(
          const AssetImage('assets/images/logo_mark.png'), context);
      for (var i = 1; i <= 10; i++) {
        await precacheImage(
          AssetImage(
              'assets/images/frames/frame_${i.toString().padLeft(2, '0')}.png'),
          context,
        );
      }
    });
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(Image), findsOneWidget);
  });
}
