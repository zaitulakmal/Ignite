import 'package:flutter_test/flutter_test.dart';
import 'package:ignite_mockup/main.dart';

void main() {
  testWidgets('Welcome screen renders', (tester) async {
    await tester.pumpWidget(const IgniteApp());
    expect(find.text('iGnite'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
