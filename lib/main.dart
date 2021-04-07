import 'package:flutter/material.dart';
import 'package:game_task_admin/select_event_main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.white,
      ),
      title: "GameTask Admin",
      debugShowCheckedModeBanner: false,
      home: SelectEvent(),
    );
  }
}
