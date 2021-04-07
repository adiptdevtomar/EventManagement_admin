import 'package:flutter/material.dart';

class HandleEvents extends StatefulWidget {
  @override
  _HandleEventsState createState() => _HandleEventsState();
}

class _HandleEventsState extends State<HandleEvents> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text("Event Info", style: TextStyle(color: Colors.black),),
              leading: GestureDetector(
                child: Icon(Icons.arrow_back_ios, color: Colors.black,),
                onTap: () {
                  Navigator.of(context).pop();
                },),
            ),
            body: Center(child: Text("Info"))
        ),
      );
  }
}
