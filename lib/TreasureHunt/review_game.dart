import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task_admin/TreasureHunt/edit_game.dart';
import '../globals.dart' as globals;

class ReviewGame extends StatefulWidget {
  @override
  _ReviewGameState createState() => _ReviewGameState();
}

class _ReviewGameState extends State<ReviewGame> {

  bool delTapped = false;

  _delGame() async {
    setState(() {
      delTapped = true;
    });

    await Firestore.instance
        .collection("TreasureHuntGame")
        .document("${globals.code}")
        .delete()
        .whenComplete(() {
      setState(() {
        globals.treasure = false;
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  _shDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text("Delete this Game?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  _delGame();
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              "Review Game",
              style: TextStyle(color: Colors.black),
            ),
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
          body: (!delTapped)
              ? StreamBuilder(
                  stream: Firestore.instance
                      .collection("TreasureHuntGame")
                      .document("${globals.code}")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: SpinKitWave(
                          size: 30.0,
                          color: Colors.indigo,
                        ),
                      );
                    } else {
                      var data = snapshot.data;
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: int.parse(data["NumberOfQues"]),
                                itemBuilder: (context, i) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    elevation: 2.0,
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("${i + 1} : ",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold)),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: AutoSizeText(
                                                  "${data["Q${i + 1}"]}",
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                width: MediaQuery.of(context).size.width * 0.77,
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Container(
                                                child: AutoSizeText(
                                                  "${data["A${i + 1}"]}",
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                                width: MediaQuery.of(context).size.width * 0.77,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                    padding: EdgeInsets.all(0.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    //color: Color(0XFF71D59D),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditGame()));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 15.0, 0.0, 15.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          gradient: LinearGradient(colors: [
                                            Color(0xFFf45d27),
                                            Color(0xFFf5851f)
                                          ])),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.edit),
                                          Text(
                                            "Edit",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  RaisedButton(
                                    padding: EdgeInsets.all(15.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    color: Colors.red,
                                    onPressed: () {
                                      _shDialog();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(
                                          Icons.delete,
                                        ),
                                        Text(
                                          "Delete",
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                )
              : SizedBox()),
    );
  }
}
