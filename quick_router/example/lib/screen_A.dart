import 'package:flutter/material.dart';
import 'package:flutter_quick_router/Routers/quick_router_transitions.dart';
import 'package:flutter_quick_router/Routers/quick_routes.dart';
import 'package:flutter_quick_router/Routers/router_builders.dart';

class ScreenA extends StatelessWidget {
  const ScreenA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Screen A')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.toNamed(
              '/screenB',
              arguments: {'message': 'Hello from Screen A'},
              transitions: const QuickRotate(),
            );
          },
          child: Text('Go to Screen B'),
        ),
      ),
    );
  }
}
