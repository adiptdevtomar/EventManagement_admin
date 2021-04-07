import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task_admin/Audio-VideoGame/preview_video.dart';
import 'package:game_task_admin/Audio-VideoGame/review_audio.dart';
import 'package:path/path.dart' as Path;

class AllAudioVideo extends StatefulWidget {
  @override
  _AllAudioVideoState createState() => _AllAudioVideoState();
}

class _AllAudioVideoState extends State<AllAudioVideo> {

  var docId;
  String url;
  var _stream;
  var lst = ["Images","Videos"];
  var _correct;

  _deleteQues() async {
    var fileUrl = Uri.decodeFull(Path.basename(url)).replaceAll(new RegExp(r'(\?alt).*'), '');
    final StorageReference fireBaseStorageRef =
    FirebaseStorage.instance.ref().child(fileUrl);
    await fireBaseStorageRef.delete();
    await Firestore.instance.collection("AudioVideo").document(docId).delete().whenComplete((){
      Navigator.of(context).pop();
    });
  }

  _shDialog() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
          ),
          title: Text("Are you sure you want to Delete this question?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: (){
                _deleteQues();
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  @override
  void initState() {
    _correct = "Images";
    _stream = Firestore.instance.collection("AudioVideo").where("Type",isEqualTo: _correct).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ReviewAudio()));
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
          title: Text(
            "All Questions",
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Filter ",style: TextStyle(fontSize: 20.0,color: Colors.orange,fontWeight: FontWeight.bold),),
                SizedBox(width: 10.0,),
                Container(
                  padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: Colors.black,
                          width: 1
                      )
                  ),
                  child: DropdownButton<String>(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    items: lst.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: _correct,
                    onChanged: (String newValue) {
                      setState(() {
                        _correct = newValue;
                        _stream = Firestore.instance.collection("AudioVideo").where("Type", isEqualTo: _correct).snapshots();
                      });
                    },
                  ),
                )
              ],
            ),
            StreamBuilder(
              stream: _stream,
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return SpinKitWave(
                    color: Colors.black,
                    size: 13.0,
                  );
                } else {
                  return ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshots.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap = snapshots.data.documents[index];
                      return Padding(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                        child: Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Container(
                            padding: EdgeInsets.only(top: 20.0,bottom: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(width: 10.0,),
                                    Text("${index + 1} : ",style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 20.0)),
                                    Container(
                                      child: AutoSizeText(
                                        "${snap["Q"]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 20.0),
                                      ),
                                      width: MediaQuery.of(context).size.width * 0.67,
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: (){
                                        docId = snap.documentID;
                                        url = snap["Url"];
                                        _shDialog();
                                      },
                                      child: Icon(Icons.delete,color: Colors.black,),
                                    ),
                                    SizedBox(width: 10.0,)
                                  ],
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                (_correct == "Images")?Center(
                                  child: Container(
                                    child: Image.network(
                                      "${snap["Url"]}",
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null) return child;
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
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.height * 0.3,
                                  ),
                                ):
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:8.0,bottom: 15.0),
                                    child: Container(
                                      child: RaisedButton(
                                        child: Text("Preview Video ->"),
                                        onPressed: (){
                                          Navigator.of(context).push(CupertinoPageRoute(builder: (context)=> PreviewVideo(url: snap["Url"],)));
                                        },
                                      )
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Center(child: Text("Answer - ${snap["A"]}",style: TextStyle(fontSize: 18.0),))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
