import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task_admin/control_page.dart';
import 'globals.dart' as globals;

class SelectEvent extends StatefulWidget {
  @override
  _SelectEventState createState() => _SelectEventState();
}

class _SelectEventState extends State<SelectEvent> {

  String pass = "";
  final _formKey = GlobalKey<FormState>();
  List<bool> isTapped = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Center(
            child: Text(
              "Control Panel",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection("Events").snapshots(),
            builder: (context, snapshots) {
              if (!snapshots.hasData) {
                return Center(
                  child: SpinKitWave(
                    color: Colors.black,
                    size: 15.0,
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshots.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot myUser = snapshots.data.documents[index];
                      if (isTapped.length != snapshots.data.documents.length) {
                        isTapped = List.generate(
                            snapshots.data.documents.length, (i) => false);
                      }
                      return ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          SizedBox(
                            height: 15.0,
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gradient: LinearGradient(colors: [
                                    Color(0xFFf45d27),
                                    Color(0xFFf5851f)
                                  ])),
                              child: ListTile(
                                dense: true,
                                onTap: () {
                                  isTapped = List.generate(
                                      snapshots.data.documents.length,
                                      (i) => false);
                                  if (isTapped[index] == true) {
                                    setState(() {
                                      isTapped[index] = false;
                                    });
                                  } else {
                                    setState(() {
                                      isTapped[index] = true;
                                    });
                                  }
                                },
                                title: Text("${myUser['Name']}"),
                              ),
                            ),
                          ),
                          (isTapped[index] == true)
                              ? SizedBox(
                                  height: 10.0,
                                )
                              : SizedBox(),
                          (isTapped[index] == true)
                              ? Container(
                                  padding:
                                      EdgeInsets.only(left: 25.0, right: 25.0),
                                  child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      onSaved: (val) {
                                        pass = val;
                                      },
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "Cannot be left Empty!";
                                        }
                                        if(val != myUser["Password"]){
                                          return "Incorrect Passowrd";
                                        }
                                        if(val == myUser["Password"]){
                                          globals.code = myUser["Code"];
                                          globals.eventName = myUser["Name"];
                                          isTapped = List.generate(
                                              snapshots.data.documents.length, (i) => false);
                                          globals.treasure = false;
                                          globals.card = false;
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ControlPage()));
                                          return null;
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          suffixIcon: GestureDetector(
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.black,
                                            ),
                                            onTap: () {
                                              _formKey.currentState.save();
                                              _formKey.currentState.validate();
                                            },
                                          ),
                                          border: OutlineInputBorder(),
                                          hintText:
                                              "Password for ${myUser['Name']}"),
                                    ),
                                  ),
                                )
                              : SizedBox()
                        ],
                      );
                    });
              }
            }),
      ),
    );
  }
}
