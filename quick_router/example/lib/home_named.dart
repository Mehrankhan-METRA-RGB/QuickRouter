import 'package:flutter/material.dart';
import 'package:flutter_quick_router/Routers/quick_router_transitions.dart';
import 'package:flutter_quick_router/Routers/quick_routes.dart';
import 'package:flutter_quick_router/Routers/router_builders.dart';

class HomeNameScreen extends StatelessWidget {
  const HomeNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //context.back();
            context.toNamed(
              '/screenA',
              transitions: const QuickSlide(start: Offset(1.0, 0.0), end: Offset.zero),
            );
          },
          child: const Text('Go to Screen A'),
        ),
      ),
    );
  }
}
