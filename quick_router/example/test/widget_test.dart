import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  ///Navigation Tests
  group('Navigation Tests', () {
    testWidgets('Navigate from HomeScreen to ScreenA', (WidgetTester tester) async {
      // Build the app and trigger a frame
      await tester.pumpWidget(const MyApp());

      //
      expect(find.text('Home Screen'), findsOneWidget);

      // Tap the button to go to Screen A
      await tester.tap(find.text('Go to Screen A'));
      await tester.pumpAndSettle(); // Wait for the navigation animation to complete


      expect(find.text('Screen A'), findsOneWidget);

    });

    testWidgets('Navigate from  ScreenB with arguments', (WidgetTester tester) async {

      await tester.pumpWidget( const MyApp());
      await tester.tap(find.text('Go to Screen A'));
      await tester.pumpAndSettle();

      // Verify that we are on ScreenA
      expect(find.text('Screen A'), findsOneWidget);

      // Tap the button to go to Screen B with arguments
      await tester.tap(find.text('Go to Screen B'));
      await tester.pumpAndSettle();

      // Verify that ScreenB is displayed and arguments are passed correctly
      expect(find.text('Screen B'), findsOneWidget);
     // expect(find.text('Received message: Hello from Screen A'), findsOneWidget);
    });

    testWidgets('Navigate back to HomeScreen from ScreenB', (WidgetTester tester) async {
      // Build the app and navigate to Screen B
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Go to Screen A'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Go to Screen B'));
      await tester.pumpAndSettle();

      // Verify that we are on Screen B
      expect(find.text('Screen B'), findsOneWidget);

      // Tap the button to go back to HomeScreen
      await tester.tap(find.text('Go back to Home'));
      await tester.pumpAndSettle();

      // Verify that HomeScreen is displayed
      expect(find.text('Home Screen'), findsOneWidget);
    });
  });
}
