import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:game_task_admin/globals.dart' as globals;
import 'package:image/image.dart' as I;

class QRCodeTreasure extends StatefulWidget {
  @override
  _QRCodeTreasureState createState() => _QRCodeTreasureState();
}

class _QRCodeTreasureState extends State<QRCodeTreasure> {
  var image;
  bool _tapped;
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _questions;
  int _numberQues;

  _shDialog(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Game Added Successfully!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Return"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  _saveGame(im, i, context) async {
    StorageReference ref =
        FirebaseStorage.instance.ref().child("Treasure/${globals.eventName}/${_questions[i].text}");
    StorageUploadTask uploadTask = ref.putData(im);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    if (url != null) {
      await Firestore.instance
          .collection("TreasureHuntGame")
          .document(globals.code)
          .collection("Questions")
          .document("Q${i + 1}")
          .setData({
        "Q": _questions[i].text,
        "Url": url,
        "Type": "QR",
      }).whenComplete(() {
        if (i == _questions.length - 1) {
          setState(() {
            _tapped = false;
            globals.treasure = true;
            print("done");
          });
          _shDialog(context);
        }
      });
    }
  }

  _allQuestion(context) {
    _questions.asMap().forEach((index, value) async {
      await toQrImageData(_questions[index].text).then((value) async {
        _saveGame(value, index, context);
      });
    });
  }

  Future<Uint8List> toQrImageData(String text) async {
    try {
      image = await QrPainter(
        data: text,
        version: QrVersions.auto,
        gapless: false,
        color: Color(0xFF000000),
        emptyColor: Color(0xFFffffff),
      ).toImage(300);
      final a = await image.toByteData(format: ImageByteFormat.png);
      var b = a.buffer.asUint8List(a.offsetInBytes, a.lengthInBytes);
      I.Image _img = I.decodeImage(b);
      var _lol = I.encodeJpg(_img);
      return _lol;
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    _tapped = false;
    _numberQues = 1;
    _questions =
        List.generate(_numberQues, (context) => new TextEditingController());
    super.initState();
  }

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
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _numberQues,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Problem ${index + 1}",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
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
                              height: 20.0,
                            ),
                            (_numberQues - 1 == index)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      RaisedButton(
                                        child: Icon(Icons.remove),
                                        onPressed: () {
                                          setState(() {
                                            if (_numberQues > 1) {
                                              _numberQues = _numberQues - 1;
                                              _questions.removeLast();
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
                                            _questions
                                                .add(TextEditingController());
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
                                FocusScope.of(context).unfocus();
                                _allQuestion(context);
                              }
                            }
                          : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        height: 50.0,
                        width: 120.0,
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
                            gradient: LinearGradient(colors: [
                              Color(0xFFf45d27),
                              Color(0xFFf5851f)
                            ])),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
