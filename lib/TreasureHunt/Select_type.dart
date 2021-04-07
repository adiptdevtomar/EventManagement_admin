import 'package:flutter/material.dart';
import 'package:game_task_admin/TreasureHunt/create_treasure_game.dart';

import 'QRCodeTreasure.dart';

class SelectType extends StatefulWidget {
  @override
  _SelectTypeState createState() => _SelectTypeState();
}

class _SelectTypeState extends State<SelectType> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: Container(
            height: 300.0,
            width: 400.0,
            child: Column(
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTreasureHunt()));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Container(
                    width: 250.0,
                    child: Center(child: Text("Normal Question-Answer")),
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                            colors: [Color(0xFFf45d27), Color(0xFFf5851f)])),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => QRCodeTreasure()));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Container(
                    width: 250.0,
                    child: Center(child: Text("QR Code Treasure Hunt")),
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                            colors: [Color(0xFFf45d27), Color(0xFFf5851f)])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
