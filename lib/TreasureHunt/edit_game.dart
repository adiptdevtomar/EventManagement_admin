import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task_admin/globals.dart' as globals;

class EditGame extends StatefulWidget {
  @override
  _EditGameState createState() => _EditGameState();
}

class _EditGameState extends State<EditGame> {

  bool isFetched = false;
  bool _tapped;
  var lol;
  final _formKey = GlobalKey<FormState>();
  var _numberQues;
  List<TextEditingController> _questions = [];
  List<TextEditingController> _answers = [];

  _shDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            title: Text("Updated Successfully!"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text("Return"),
              )
            ],
          );
        });
  }

  _updateGame() async {
    var _details = Map<String, String>();
    _details["NumberOfQues"] = "$_numberQues";
    for (var i = 0; i < _numberQues; i++) {
      _details["Q${i + 1}"] = "${_questions[i].text}";
      _details["A${i + 1}"] = "${_answers[i].text}";
    }

    await Firestore.instance
        .collection("TreasureHuntGame")
        .document("${globals.code}")
        .setData(_details)
        .whenComplete(() {
      setState(() {
        _tapped = false;
      });
      _shDialog();
    });
  }

  _fetchValues() async {
    await Firestore.instance
        .collection("TreasureHuntGame")
        .document(globals.code)
        .get()
        .then((onValue) {
      lol = onValue.data;
    }).whenComplete(() {
      _numberQues = int.parse(lol["NumberOfQues"]);
      for (int i = 1; i < _numberQues + 1; i++) {
        _questions.add(TextEditingController(text: lol["Q$i"]));
        _answers.add(TextEditingController(text: lol["A$i"]));
      }
      setState(() {
        isFetched = true;
      });
    });
  }

  @override
  void initState() {
    _fetchValues();
    _tapped = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Create Game",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: (isFetched)
            ? Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _numberQues,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Problem: ${index + 1}",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Cannot be left empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: _questions[index],
                                        maxLines: null,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "Answer: ",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Cannot be left empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: _answers[index],
                                        maxLines: null,
                                        decoration: InputDecoration(
                                            hintText: "Not Case Sensitive",
                                            hintStyle:
                                                TextStyle(fontSize: 10.0)),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      (_numberQues - 1 == index)
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                RaisedButton(
                                                  child: Icon(Icons.remove),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (_numberQues > 1) {
                                                        _numberQues =
                                                            _numberQues - 1;
                                                        _questions.removeLast();
                                                        _answers.removeLast();
                                                      }
                                                    });
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                RaisedButton(
                                                  child: Icon(Icons.add),
                                                  onPressed: () {
                                                    setState(() {
                                                      _numberQues =
                                                          _numberQues + 1;
                                                      _questions.add(
                                                          TextEditingController());
                                                      _answers.add(
                                                          TextEditingController());
                                                    });
                                                  },
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                    ],
                                  )),
                            );
                          },
                        )),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: (!_tapped)
                              ? () {
                                  if (_formKey.currentState.validate()) {
                                    _updateGame();
                                    setState(() {
                                      _tapped = true;
                                    });
                                  }
                                }
                              : null,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Container(
                            width: 100.0,
                            child: (_tapped)
                                ? Center(
                                    child: SpinKitWave(
                                      size: 14.0,
                                      color: Colors.black,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "Update",
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                            padding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                gradient: LinearGradient(colors: [
                                  Color(0xFFf45d27),
                                  Color(0xFFf5851f)
                                ])),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : SpinKitWave(
                size: 13.0,
                color: Colors.black,
              ),
      ),
    );
  }
}
