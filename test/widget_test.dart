import 'package:flutter_test/flutter_test.dart';
import 'package:p2p_demo/main.dart';

void main() {
  testWidgets('App startet', (WidgetTester tester) async {
    await tester.pumpWidget(const P2PApp());
    expect(find.text('P2P Demo'), findsOneWidget);
  });
}
