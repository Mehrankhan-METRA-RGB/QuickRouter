import 'package:example/home_named.dart';
import 'package:example/screen_A.dart';
import 'package:example/screen_b.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quick_router/quick_router.dart';

QuickTransition defaultTransition = QuickFade();

// QuickSlide(
//   animate: CurveTween(curve: Curves.fastEaseInToSlowEaseOut),
//   // transitionDuration: const Duration(seconds: 2),
//   // reverseTransitionDuration: const Duration(seconds: 2)
// );

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QUICK ROUTER',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeNameScreen(),
        '/screenA': (context) => ScreenA(),
        '/screenB': (context) => ScreenB(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    //  home: const HomeScreen(),
    );
  }
}

// A widget that defines the main screen of the app
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // A button that navigates to the second screen using the to() method
            ElevatedButton(
              onPressed: () {
                context.to(const SecondScreen(),
                    transitions: defaultTransition);

                ///ROTATION ANIMATION TRANSITION
                //const QuickRotate(
                //                         start: 0,
                //                         end: 1,
                //                         alignment: Alignment.center,
                //                         filterQuality: FilterQuality.low)
              },
              child: const Text('Go to second screen'),
            ),
            // A button that navigates to the third screen using the pushReplacement() method
            ElevatedButton(
              onPressed: () {
                context.pushReplacement(const ThirdScreen(),
                    transitions: defaultTransition, result: 'Hello from home');
              },
              child: const Text('Replace with third screen'),
            ),
            // A button that navigates to the fourth screen using the pushAndRemoveUntil() method
            ElevatedButton(
              onPressed: () {
                context.pushAndRemoveUntil(
                  const FourthScreen(),
                  transitions: defaultTransition,
                  (route) => route.isFirst,
                );
              },
              child:
                  const Text('Remove all except first and go to fourth screen'),
            ),
            // A button that navigates to the fifth screen using the restorablePushAndRemoveUntil() method
            ElevatedButton(
              onPressed: () {
                context.restorablePushAndRemoveUntil(
                  (context, arguments) => MaterialPageRoute(
                    builder: (context) => const FifthScreen(),
                  ),
                  (route) => false,
                  arguments: <String, String>{"key": 'Some arguments'},
                );
              },
              child: const Text(
                  'Remove all and go to fifth screen with restoration'),
            ),
          ],
        ),
      ),
    );
  }
}

// A widget that defines the second screen of the app
class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // A button that returns to the previous screen using the back() method
            ElevatedButton(
              onPressed: () {
                context.back('Hello from second');
              },
              child: const Text('Go back with result'),
            ),
            // A button that replaces the current screen with the third screen using the replace() method
            ElevatedButton(
              onPressed: () {
                context.replace(
                    old: this,
                    to: const ThirdScreen(),
                    transitions: defaultTransition);
              },
              child: const Text('Replace with third screen'),
            ),
            // A button that replaces the route below the current one with the fourth screen using the replaceRouteBelow() method
            ElevatedButton(
              onPressed: () {
                context.replaceRouteBelow(
                  anchor: this,
                  to: const FourthScreen(),
                );
              },
              child: const Text('Replace route below with fourth screen'),
            ),
            // A button that replaces the current screen with the fifth screen using the restorableReplace() method
            ElevatedButton(
              onPressed: () {
                context.restorableReplace(
                  old: this,
                  transitions: defaultTransition,
                  to: (context, arguments) => MaterialPageRoute(
                    builder: (context) => const FifthScreen(),
                    settings: const RouteSettings(name: '/fifth'),
                  ),
                  arguments: 'Some arguments',
                );
              },
              child: const Text('Replace with fifth screen with restoration'),
            ),
          ],
        ),
      ),
    );
  }
}

// A widget that defines the third screen of the app
class ThirdScreen extends StatelessWidget {
  const ThirdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Third Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // A button that returns to the previous screen using the back() method
            ElevatedButton(
              onPressed: () {
                context.to(const HomeScreen(), transitions: defaultTransition);
              },
              child: const Text('Go back with result'),
            ),
          ],
        ),
      ),
    );
  }
}

// A widget that defines the fourth screen of the app
class FourthScreen extends StatelessWidget {
  const FourthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fourth Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // A button that returns to the previous screen using the back() method
            ElevatedButton(
              onPressed: () {
                context.back('Hello from fourth');
              },
              child: const Text('Go back with result'),
            ),
          ],
        ),
      ),
    );
  }
}

// A widget that defines the fifth screen of the app
class FifthScreen extends StatelessWidget {
  const FifthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fifth Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // A button that returns to the previous screen using the back() method
            ElevatedButton(
              onPressed: () {
                context.back('Hello from fifth');
              },
              child: const Text('Go back with result'),
            ),
          ],
        ),
      ),
    );
  }
}
