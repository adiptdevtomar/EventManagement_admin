import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../globals.dart' as globals;

class ReviewCard extends StatefulWidget {
  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {

  var _details;
  bool hasDetails = false;
  bool _delTapped = false;

  _shDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text("Are you sure you want to delete this game?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  _deleteCard();
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

  _deleteCard() async {
    setState(() {
      _delTapped = true;
    });
    await Firestore.instance
        .collection("PlayerCard")
        .document("${globals.code}")
        .delete()
        .whenComplete(() {
      setState(() {
        globals.card = false;
      });
      Navigator.of(context).pop();
      Navigator.pop(context);
    });
  }

  _getDetails() async {
    await Firestore.instance
        .collection("PlayerCard")
        .document(globals.code)
        .get()
        .then((value) {
      _details = value.data;
    }).whenComplete(() {
      setState(() {
        hasDetails = true;
      });
    });
  }

  @override
  void initState() {
    _getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Review Card Details",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.orange,
              ),
              onTap: () {
                _shDialog();
              },
            ),
            SizedBox(width: 13.0),
          ],
          elevation: 0.0,
        ),
        body: (hasDetails)
            ? Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(7.0, 7.0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          width: 1,
                        )),
                    padding: EdgeInsets.only(
                        top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Center(
                            child: Column(
                          children: <Widget>[
                            Text(
                              "Player Card",
                              style: TextStyle(
                                  fontSize: 22.0, color: Colors.black),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Align(
                              child: Text(
                                "${_details["ToGuess"]}",
                                style: TextStyle(fontSize: 18.0),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              enabled: false,
                              decoration:
                                  InputDecoration(border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Align(
                              child: Text(
                                "*Field To guess",
                                style: TextStyle(color: Colors.orange),
                              ),
                              alignment: Alignment.centerRight,
                            ),
                            SizedBox(
                              height: 10.0,
                            )
                          ],
                        )),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: int.parse(_details["Fields"]),
                          itemBuilder: (context, index) {
                            return ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                Text(
                                  "${_details["F${index + 1}"]}",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                (index + 1 == int.parse(_details["Fields"]))
                                    ? Column(
                                        children: <Widget>[
                                          FlatButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            onPressed: () {
                                              print("yes");
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(2.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFFf45d27),
                                                          Color(0xFFf5851f)
                                                        ])),
                                                child: SizedBox(
                                                    width: 150.0,
                                                    height: 40.0,
                                                    child: Center(
                                                      child: Text(
                                                        "Proceed",
                                                        style: TextStyle(
                                                            fontSize: 15.0),
                                                      ),
                                                    ))),
                                            padding: EdgeInsets.all(0.0),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 10.0,
                                )
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: SpinKitWave(
                  color: Colors.black,
                  size: 13.0,
                ),
              ),
      ),
    );
  }
}
