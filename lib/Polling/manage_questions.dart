import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task_admin/Polling/Review_Question.dart';
import 'package:game_task_admin/Polling/all_categories.dart';
import 'package:game_task_admin/globals.dart' as globals;

class ManageQues extends StatefulWidget {
  @override
  _ManageQuesState createState() => _ManageQuesState();
}

class _ManageQuesState extends State<ManageQues> {

  List<bool> isChecked = [];
  var docID;
  var def;
  var run = false;
  bool absorb = true;

  _getDefaultCat() async {
    await Firestore.instance
        .collection("Events")
        .where("Code", isEqualTo: globals.code)
        .getDocuments()
        .then((onValue) {
      onValue.documents.forEach((f) {
        def = f.data["pollCat"];
        docID = f.documentID;
      });
    }).whenComplete(() {
      setState(() {
        absorb = false;
      });
    });
  }

  _changeCategory(str) async {
    await Firestore.instance
        .collection("Events")
        .document(docID)
        .updateData({"pollCat": str}).whenComplete(() {
      setState(() {
        absorb = false;
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _getDefaultCat());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Manage Questions",
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
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              Container(
                height: 220.0,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Number of Questions:",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection("Poll Questions")
                              .snapshots(),
                          builder: (context, snapshots) {
                            if (!snapshots.hasData) {
                              return SpinKitWave(
                                color: Colors.orange,
                                size: 13.0,
                              );
                            } else {
                              return Text("${snapshots.data.documents.length}",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold));
                            }
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Categories of Questions:",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection("AdminControls")
                              .document("Categories")
                              .snapshots(),
                          builder: (context, snapshots) {
                            if (!snapshots.hasData) {
                              return SpinKitWave(
                                color: Colors.orange,
                                size: 13.0,
                              );
                            } else {
                              return Text("${snapshots.data["No"]}",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold));
                            }
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          //color: Color(0XFF71D59D),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReviewQues()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                gradient: LinearGradient(colors: [
                                  Color(0xFFf45d27),
                                  Color(0xFFf5851f)
                                ])),
                            child: Text(
                              "Review Questions",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          //color: Color(0XFF71D59D),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AllCategories()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                gradient: LinearGradient(colors: [
                                  Color(0xFFf45d27),
                                  Color(0xFFf5851f)
                                ])),
                            child: Text(
                              "Review Category",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                "Select Category for your Event",
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              AbsorbPointer(
                absorbing: absorb,
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("AdminControls")
                        .document("Categories")
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (!snapshots.hasData) {
                        return Center(
                          child: SpinKitWave(
                            color: Colors.black,
                            size: 13.0,
                          ),
                        );
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshots.data["No"],
                            itemBuilder: (context, index) {
                              var myUser = snapshots.data;
                              if (isChecked.length != snapshots.data["No"]) {
                                isChecked = List.generate(
                                    snapshots.data["No"], (i) => false);
                              }
                              if (run == false) {
                                if (myUser["cat${index + 1}"] == def) {
                                  isChecked[index] = true;
                                  run = true;
                                }
                              }
                              return ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  CheckboxListTile(
                                    title: Text(myUser["cat${index + 1}"]),
                                    activeColor: Colors.deepOrange,
                                    dense: true,
                                    value: isChecked[index],
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    onChanged: (val) {
                                      isChecked = List.generate(
                                          snapshots.data["No"], (i) => false);
                                      setState(() {
                                        isChecked[index] = true;
                                        absorb = true;
                                      });
                                      _changeCategory(
                                          myUser["cat${index + 1}"]);
                                    },
                                  ),
                                ],
                              );
                            });
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
