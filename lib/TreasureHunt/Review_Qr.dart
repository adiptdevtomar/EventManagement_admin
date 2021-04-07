import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_downloader/image_downloader.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task_admin/globals.dart' as globals;

class ReviewQR extends StatefulWidget {
  @override
  _ReviewQRState createState() => _ReviewQRState();
}

class _ReviewQRState extends State<ReviewQR> {
  var _equal;
  bool _downTapped = false;
  var taskId;
  bool delTapped = false;
  List<bool> _downloads = [];

  _imageDownload(url, name, index) async {
    await ImageDownloader.downloadImage(url).then((imageId) async {
      setState(() {
        _downTapped = false;
        _downloads[index] = false;
      });
    });
  }

  _delGame() async {
    setState(() {
      delTapped = true;
    });

    await Firestore.instance
        .collection("TreasureHuntGame")
        .document(globals.code)
        .collection("Questions")
        .getDocuments()
        .then((value) {
      value.documents.asMap().forEach((key, value) async {
        StorageReference photoRef = await FirebaseStorage.instance
            .getReferenceFromUrl(value.data["Url"]);
        photoRef.delete();
        value.reference.delete();
      });
    }).whenComplete(() {
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
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: (!delTapped)
            ? StreamBuilder(
                stream: Firestore.instance
                    .collection("TreasureHuntGame")
                    .document("${globals.code}")
                    .collection("Questions")
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
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                snapshot.data.documents[index];
                            if (_equal != snapshot.data.documents.length) {
                              _downloads = List.generate(
                                  snapshot.data.documents.length,
                                  (index) => false);
                              _equal = snapshot.data.documents.length;
                            }
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 2.0,
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("${index + 1} : ",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          child: AutoSizeText(
                                            "${snap["Q"]}",
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.77,
                                        ),
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                        Container(
                                          child: Image.network(
                                            "${snap["Url"]}",
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child: Container(
                                                  height: 100.0,
                                                  width: 100.0,
                                                  child: Center(
                                                    child: SpinKitWave(
                                                      size: 20.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        (_downloads[index])
                                            ? SizedBox(
                                                height: 48.0,
                                                child: SpinKitWave(
                                                  color: Colors.black,
                                                  size: 13.0,
                                                ),
                                              )
                                            : RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text("Download"),
                                                ),
                                                onPressed: (_downTapped)
                                                    ? () {}
                                                    : () async {
                                                        setState(() {
                                                          _downTapped = true;
                                                          _downloads[index] =
                                                              true;
                                                        });
                                                        _imageDownload(
                                                            snap["Url"],
                                                            snap["Q"],
                                                            index);
                                                      },
                                                color: Colors.deepOrange,
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              )
            : SizedBox(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _shDialog();
          },
          backgroundColor: Colors.red,
          child: Icon(Icons.delete),
        ),
      ),
    );
  }
}
