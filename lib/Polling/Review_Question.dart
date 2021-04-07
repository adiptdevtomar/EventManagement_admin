import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task_admin/Polling/add_question.dart';

class ReviewQues extends StatefulWidget {
  @override
  _ReviewQuesState createState() => _ReviewQuesState();
}

class _ReviewQuesState extends State<ReviewQues> {
  List<String> lst = [];
  var docID;
  bool isTapped = false;
  bool hasList = false;
  var _correct = 'All Category';
  var stream = Firestore.instance.collection("Poll Questions").snapshots();

  _deleteQues() async {
    await Firestore.instance
        .collection("Poll Questions")
        .document(docID)
        .delete();
  }

  _getCategories() async {
    await Firestore.instance
        .collection("AdminControls")
        .document("Categories")
        .get()
        .then((onValue) {
      for (int i = 0; i < onValue.data["No"]; i++) {
        lst.add(onValue.data["cat${i + 1}"]);
      }
    });
    lst.add("All Category");
    setState(() {
      hasList = true;
    });
  }

  _shDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text("Delete this?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteQues();
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
    _getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "All Questions",
            style: TextStyle(fontSize: 20.0, color: Colors.black),
          ),
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
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 0.0),
              child: GestureDetector(
                child: Text(
                  "Add",
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AddQues()));
                },
              ),
            )
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Filter ",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black, width: 1)),
                  child: (hasList)
                      ? DropdownButton<String>(
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
                              stream = Firestore.instance
                                  .collection("Poll Questions")
                                  .where("Category", isEqualTo: _correct)
                                  .snapshots();
                              if (_correct == "All Category") {
                                stream = Firestore.instance
                                    .collection("Poll Questions")
                                    .snapshots();
                              }
                            });
                          },
                        )
                      : SizedBox(),
                )
              ],
            ),
            StreamBuilder(
              stream: stream,
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: SpinKitWave(
                      color: Colors.black,
                      size: 15.0,
                    ),
                  );
                } else {
                  return ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshots.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot details =
                          snapshots.data.documents[index];
                      var len = details.data.keys.length;
                      return Card(
                        margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        "${details["Q1"]}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: CircleAvatar(
                                        radius: 17.0,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                      onTap: () {
                                        _shDialog();
                                        docID = details.documentID;
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Category",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12.0),
                                    ),
                                    SizedBox(
                                      width: 2.0,
                                    ),
                                    CircleAvatar(
                                      radius: 2,
                                      backgroundColor: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 2.0,
                                    ),
                                    Text(
                                      "${details["Category"]}",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12.0),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: ((len - 3) / 2).round(),
                                  itemBuilder: (context, index) {
                                    return Text(
                                        "${index + 1} : ${details["A${index + 1}"]}");
                                  },
                                ),
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
