import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quick_router/Routers/router_builders.dart';
import 'package:flutter_quick_router/quick_router.dart';

void main() {
  group('QuickRouter named routes', () {
    final List<QuickNamedRoute> namedRoutes = <QuickNamedRoute>[
      const QuickNamedRoute(
        name: '/details',
        builder: _detailsScreen,
        transitions: QuickFade(),
      ),
      const QuickNamedRoute(
        name: '/replacement',
        builder: _replacementScreen,
        transitions: QuickSlide(),
      ),
    ];

    testWidgets('pushNamed navigates through onGenerateRoute with arguments',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const _HomeScreen(),
          onGenerateRoute: QuickRouter.onGenerateRoute(namedRoutes),
        ),
      );

      await tester.tap(find.text('Open details'));
      await tester.pumpAndSettle();

      expect(find.text('details:payload'), findsOneWidget);
    });

    testWidgets('pushReplacementNamed replaces the current route',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const _ReplacementHomeScreen(),
          onGenerateRoute: QuickRouter.onGenerateRoute(namedRoutes),
        ),
      );

      await tester.tap(find.text('Replace route'));
      await tester.pumpAndSettle();

      expect(find.text('replacement screen'), findsOneWidget);
      expect(find.text('Replace route'), findsNothing);
    });

    testWidgets('routes creates a MaterialApp routes map',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const _RoutesHomeScreen(),
          routes: QuickRouter.routes(<QuickNamedRoute>[
            const QuickNamedRoute(name: '/simple', builder: _simpleScreen),
          ]),
        ),
      );

      await tester.tap(find.text('Open simple'));
      await tester.pumpAndSettle();

      expect(find.text('simple route'), findsOneWidget);
    });

    test('onGenerateRoute returns null for unknown names', () {
      final RouteFactory routeFactory =
          QuickRouter.onGenerateRoute(namedRoutes);

      expect(
        routeFactory(const RouteSettings(name: '/missing')),
        isNull,
      );
    });
  });
}

Widget _detailsScreen(BuildContext context, Object? arguments) {
  return Scaffold(
    body: Text('details:${arguments as String? ?? 'none'}'),
  );
}

Widget _replacementScreen(BuildContext context, Object? arguments) {
  return const Scaffold(
    body: Text('replacement screen'),
  );
}

Widget _simpleScreen(BuildContext context, Object? arguments) {
  return const Scaffold(
    body: Text('simple route'),
  );
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            context.pushNamed('/details', arguments: 'payload');
          },
          child: const Text('Open details'),
        ),
      ),
    );
  }
}

class _ReplacementHomeScreen extends StatelessWidget {
  const _ReplacementHomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            context.pushReplacementNamed('/replacement');
          },
          child: const Text('Replace route'),
        ),
      ),
    );
  }
}

class _RoutesHomeScreen extends StatelessWidget {
  const _RoutesHomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            context.pushNamed('/simple');
          },
          child: const Text('Open simple'),
        ),
      ),
    );
  }
}
