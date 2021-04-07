import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../globals.dart' as globals;

class CreateTreasureHunt extends StatefulWidget {
  @override
  _CreateTreasureHuntState createState() => _CreateTreasureHuntState();
}

class _CreateTreasureHuntState extends State<CreateTreasureHunt> {
  bool _tapped;
  int _numberQues;
  final _formKey = GlobalKey<FormState>();

  List<TextEditingController> _questions;
  List<TextEditingController> _answers;

  void _shDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text("Added Successfully"),
            actions: <Widget>[
              FlatButton(
                child: Text("Return"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future _addGame() async {
    var _details = Map<String, String>();
    _details["NumberOfQues"] = "$_numberQues";
    _details["Type"] = "Normal";
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
        globals.treasure = true;
        _tapped = false;
      });
      _shDialog();
    });
  }

  void initState() {
    super.initState();
    _tapped = false;
    _numberQues = 1;
    _questions =
        List.generate(_numberQues, (context) => new TextEditingController());
    _answers =
        List.generate(_numberQues, (context) => new TextEditingController());
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
        body: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _numberQues,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Problem ${index + 1}",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10.0,),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )
                            ),
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
                            "Answer",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10.0,),
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                hintStyle: TextStyle(fontSize: 10.0)),
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
                                            _numberQues = _numberQues - 1;
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
                                          _numberQues = _numberQues + 1;
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
                      ));
                },
              ),
              Column(
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: (!_tapped)
                        ? () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _tapped = true;
                              });
                              _addGame();
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
                                "Submit",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                              colors: [Color(0xFFf45d27), Color(0xFFf5851f)])),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
