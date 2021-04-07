import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart';

class ReviewAudio extends StatefulWidget {
  @override
  _ReviewAudioState createState() => _ReviewAudioState();
}

class _ReviewAudioState extends State<ReviewAudio> {
  bool isTapped = false;
  var count = 0;
  var ques;
  var ans;
  File _image;
  File _video;
  final _formKey = GlobalKey<FormState>();
  VideoPlayerController _videoPlayerController;

  _saveGame(context) async {
    if (_image != null) {
      String fileName = basename(_image.path);
      StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = ref.putFile(_image);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      if (url != null) {
        await Firestore.instance.collection("AudioVideo").add({
          "Q": ques,
          "A": ans,
          "Url": url,
          "Type": "Images"
        }).whenComplete(() {
          setState(() {
            isTapped = false;
            _shDialog(context);
          });
        });
      }
    } else {
      String fileName = basename(_video.path);
      StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = ref.putFile(_video);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      print(url);
      if (url != null) {
        await Firestore.instance.collection("AudioVideo").add({
          "Q": ques,
          "A": ans,
          "Url": url,
          "Type": "Videos"
        }).whenComplete(() {
          setState(() {
            isTapped = false;
            _shDialog(context);
          });
        });
      }
    }
  }

  _shDialog(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
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

  _pickImage() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  _pickVideo() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    _video = video;
    if (_video != null) {
      _videoPlayerController = VideoPlayerController.file(_video)
        ..initialize().then((_) {
          setState(() {
            _videoPlayerController.play();
          });
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Add Question",
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
        body: SafeArea(
          child: Scaffold(
              body: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    "Question",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    initialValue: ques,
                    onChanged: (val){
                      ques = val;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Cannot be left Empty";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(hintText: "e.g. Name the Logo"),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (_image != null)
                          ? Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Center(child: Image.file(_image)),
                              ),
                            )
                          : (_video == null)
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30.0),
                                  child: RaisedButton(
                                    child: Text("+ Image"),
                                    onPressed: () {
                                      _pickImage();
                                    },
                                  ),
                                )
                              : SizedBox(),
                      SizedBox(
                        width: 10.0,
                      ),
                      (_image == null && _video == null)
                          ? Text("Or")
                          : SizedBox(),
                      SizedBox(
                        width: 10.0,
                      ),
                      (_video != null)
                          ? _videoPlayerController.value.initialized
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height:
                                      MediaQuery.of(context).size.height * 0.40,
                                  child: AspectRatio(
                                    aspectRatio: _videoPlayerController
                                        .value.aspectRatio,
                                    child: VideoPlayer(_videoPlayerController),
                                  ),
                                )
                              : SizedBox()
                          : (_image == null)
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30.0),
                                  child: RaisedButton(
                                    child: Text("+ Video"),
                                    onPressed: () {
                                      _pickVideo();
                                    },
                                  ),
                                )
                              : SizedBox()
                    ],
                  ),
                  (_image != null)
                      ? SizedBox(
                          height: 10.0,
                        )
                      : SizedBox(),
                  (_image != null)
                      ? Center(
                          child: InkWell(
                            child: Text(
                              "Remove?",
                              style: TextStyle(color: Colors.orange),
                            ),
                            onTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
                          ),
                        )
                      : SizedBox(),
                  (_video != null)
                      ? SizedBox(
                          height: 10.0,
                        )
                      : SizedBox(),
                  (_video != null)
                      ? Center(
                          child: InkWell(
                            child: Text(
                              "Remove?",
                              style: TextStyle(color: Colors.orange),
                            ),
                            onTap: () {
                              setState(() {
                                _videoPlayerController.pause();
                                _video = null;
                              });
                            },
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Answer",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    initialValue: ans,
                    onChanged: (val){
                      ans = val;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Cannot be left Empty";
                      }
                      if (_image == null && _video == null) {
                        return "Please Select a video or image";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(hintText: "e.g. Google"),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              isTapped = true;
                            });
                            _saveGame(context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradient(colors: [
                                Color(0xFFf45d27),
                                Color(0xFFf5851f)
                              ])),
                          child: (isTapped)
                              ? SizedBox(
                                  width: 30.0,
                                  child: SpinKitWave(
                                    color: Colors.black,
                                    size: 13.0,
                                  ),
                                )
                              : Text(
                                  'Save',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                        ),
                        //color: Color(0XFF71D59D),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
