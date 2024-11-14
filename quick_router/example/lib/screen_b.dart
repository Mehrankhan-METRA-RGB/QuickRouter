import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_quick_router/Routers/quick_router_transitions.dart';
import 'package:flutter_quick_router/Routers/quick_routes.dart';
import 'package:flutter_quick_router/Routers/router_builders.dart';

class ScreenB extends StatefulWidget {
  const ScreenB({super.key});

  @override
  State<ScreenB> createState() => _ScreenBState();
}

class _ScreenBState extends State<ScreenB> {
  String? argumentsRecevied;
  @override
  void initState() {   // Retrieve arguments passed from ScreenA

    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    var arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final  String message = arguments?['message'] ?? 'No message received';
    print(message);
    argumentsRecevied=message;
SchedulerBinding.instance.addPostFrameCallback((_) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("argument recieved from screen A: $argumentsRecevied")));

});
    // TODO: implement initState
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Screen B')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.toNamed(
              '/',
              transitions: QuickFade(),
            );
          },
          child: Text('Go back to Home'),
        ),
      ),
    );
  }
}
