import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../globals.dart' as globals;

class EditCard extends StatefulWidget {
  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  TextEditingController _guess = TextEditingController();
  bool isTapped = false;
  final _formKey = GlobalKey<FormState>();
  var _numberOfFields;
  List<TextEditingController> _fields;

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

  _addCard() async {
    var _details = Map<String, String>();
    _details["ToGuess"] = "${_guess.text}";
    _details["Fields"] = "$_numberOfFields";
    for (var i = 0; i < _numberOfFields; i++) {
      _details["F${i + 1}"] = "${_fields[i].text}";
    }

    await Firestore.instance
        .collection("PlayerCard")
        .document("${globals.code}")
        .setData(_details)
        .whenComplete(() {
      setState(() {
        globals.card = true;
        isTapped = false;
      });
      _shDialog();
    });
  }

  @override
  void initState() {
    _numberOfFields = 1;
    _fields = List.generate(
        _numberOfFields, (context) => new TextEditingController());
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
          actions: <Widget>[
            (isTapped)
                ? SizedBox(
                    width: 50.0,
                    child: SpinKitWave(
                      size: 13.0,
                      color: Colors.orange,
                    ),
                  )
                : InkWell(
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          isTapped = true;
                        });
                        _addCard();
                      }
                    },
                    child: Center(
                        child: Text(
                      "Save",
                      style: TextStyle(color: Colors.orange, fontSize: 20.0),
                    )),
                  ),
            SizedBox(
              width: 18.0,
            )
          ],
        ),
        body: Align(
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
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Center(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "Player Card",
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Field To Guess"
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Cannot be left empty";
                            } else {
                              return null;
                            }
                          },
                          controller: _guess,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    )),
                    Container(
                      child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _numberOfFields,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Cannot be left empty";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: _fields[index],
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: "Field ${index+1}",
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              (_numberOfFields - 1 == index)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        RaisedButton(
                                          child: Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              if (_numberOfFields > 1) {
                                                _numberOfFields =
                                                    _numberOfFields - 1;
                                                _fields.removeLast();
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
                                              _numberOfFields =
                                                  _numberOfFields + 1;
                                              _fields
                                                  .add(TextEditingController());
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
