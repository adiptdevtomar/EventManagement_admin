import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task_admin/Audio-VideoGame/all_audiovideo.dart';
import 'package:game_task_admin/Event/handle_events.dart';
import 'package:game_task_admin/GuessingGame/edit_card.dart';
import 'package:game_task_admin/GuessingGame/review_card.dart';
import 'package:game_task_admin/Polling/manage_questions.dart';
import 'package:game_task_admin/TreasureHunt/QRCodeTreasure.dart';
import 'package:game_task_admin/TreasureHunt/Review_Qr.dart';
import 'package:game_task_admin/TreasureHunt/create_treasure_game.dart';
import 'package:game_task_admin/TreasureHunt/review_game.dart';
import 'globals.dart' as globals;

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  bool hasData = false;

  _deleteEvent() async {}

  _getTreasure() async {
    DocumentSnapshot snap = await Firestore.instance
        .collection("TreasureHuntGame")
        .document(globals.code)
        .collection("Questions")
        .document("Q1")
        .get();
    if (snap.exists) {
      setState(() {
        globals.treasure = true;
      });
    } else {
      print("No Treasure");
    }
  }

  _getCard() async {
    await Firestore.instance
        .collection("PlayerCard")
        .getDocuments()
        .then((onValue) {
      onValue.documents.forEach((f) {
        if (f.documentID == globals.code) {
          setState(() {
            globals.card = true;
          });
        }
      });
    }).whenComplete(() {
      setState(() {
        hasData = true;
      });
    });
  }

  _shDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text("Leave Event"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    _getTreasure();
    _getCard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        _shDialog();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Control Page",
              style: TextStyle(color: Colors.black),
            ),
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onTap: () {
                _shDialog();
              },
            ),
            elevation: 0.0,
          ),
          body: (hasData)
              ? Container(
                  padding: EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        //color: Color(0XFF71D59D),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HandleEvents()));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradient(colors: [
                                Color(0xFFf45d27),
                                Color(0xFFf5851f)
                              ])),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              "Event Info",
                              style: TextStyle(color: Colors.black),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        //color: Color(0XFF71D59D),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradient(colors: [
                                Color(0xFFf45d27),
                                Color(0xFFf5851f)
                              ])),
                          child: ListTile(
                            onTap: (globals.treasure)
                                ? () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => ReviewQR()))
                                        .then((value) {
                                      if (globals.treasure == false) {
                                        setState(() {
                                          globals.treasure = false;
                                        });
                                      }
                                    });
                                  }
                                : () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                QRCodeTreasure()))
                                        .then((value) {
                                      if (globals.treasure == false) {
                                        setState(() {
                                          globals.treasure = false;
                                        });
                                      }
                                    });
                                  },
                            dense: true,
                            title: Text(
                              "Treasure Hunt Game",
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: (globals.treasure)
                                ? Text("Already Has a Game")
                                : null,
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        //color: Color(0XFF71D59D),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ManageQues()));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradient(colors: [
                                Color(0xFFf45d27),
                                Color(0xFFf5851f)
                              ])),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              "Poll Questions",
                              style: TextStyle(color: Colors.black),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        //color: Color(0XFF71D59D),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradient(colors: [
                                Color(0xFFf45d27),
                                Color(0xFFf5851f)
                              ])),
                          child: ListTile(
                            onTap:
                                /*(){
                          Fluttertoast.showToast(
                            msg: "Coming Soon!"
                          );
                        }*/
                                (globals.card)
                                    ? () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ReviewCard()))
                                            .then((value) {
                                          if (globals.card == false) {
                                            setState(() {
                                              globals.card = false;
                                            });
                                          }
                                        });
                                      }
                                    : () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    EditCard()))
                                            .then((value) {
                                          if (globals.card == false) {
                                            setState(() {
                                              globals.card = false;
                                            });
                                          }
                                        });
                                      },
                            subtitle: (globals.card)
                                ? Text("Already has a Card")
                                : null,
                            dense: true,
                            title: Text(
                              "Guess Player",
                              style: TextStyle(color: Colors.black),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        //color: Color(0XFF71D59D),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AllAudioVideo()));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradient(colors: [
                                Color(0xFFf45d27),
                                Color(0xFFf5851f)
                              ])),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              "Audio/Video Game",
                              style: TextStyle(color: Colors.black),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SpinKitWave(
                    color: Colors.black,
                    size: 15.0,
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            backgroundColor: Colors.red,
            onPressed: () {
              _deleteEvent();
            },
          ),
        ),
      ),
    );
  }
}
