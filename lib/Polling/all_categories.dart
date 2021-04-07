import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AllCategories extends StatefulWidget {
  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  TextEditingController _controller = TextEditingController();

  bool isAdded = false;
  bool isTapped = false;
  var _name;
  var count;
  final _formKey = GlobalKey<FormState>();
  var lst;

  _getCat() async {
    await Firestore.instance
        .collection("AdminControls")
        .document("Categories")
        .get()
        .then((onValue) {
      lst = onValue.data.values;
    });
  }

  _shDialog(index) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(
                "Delete Category? This will also delete all questions of this Category."),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isTapped = true;
                  });
                  _delCategory();
                },
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No"),
              )
            ],
          );
        });
  }

  _delCategory() async {
    var lol;
    await Firestore.instance
        .collection("AdminControls")
        .document("Categories")
        .get()
        .then((onValue) {
      lol = onValue.data;
    });

    int j = 1;
    var _details = Map<String, dynamic>();
    _details["No"] = lol["No"] - 1;
    for (int i = 1; i <= lol["No"]; i++) {
      if (lol["cat$i"] != _name) {
        _details["cat$j"] = lol["cat$i"];
        j = j + 1;
      }
    }

    var db = Firestore.instance;
    var batch = db.batch();

    batch.setData(
        db.collection("AdminControls").document("Categories"), _details);

    Firestore.instance
        .collection("Poll Questions")
        .where("Category", isEqualTo: _name)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        batch.delete(element.reference);
      });
    }).whenComplete(() {
      Firestore.instance
          .collection("Events")
          .where("pollCat", isEqualTo: _name)
          .getDocuments()
          .then((value) {
        value.documents.forEach((ele) {
          batch.updateData(ele.reference, {"pollCat": ""});
        });
      }).whenComplete(() {
        batch.commit().whenComplete(() {
          _getCat();
          setState(() {
            isTapped = false;
          });
        });
      });
    });
  }

  _addCategory() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isAdded = true;
      });

      await Firestore.instance
          .collection("AdminControls")
          .document("Categories")
          .updateData({
        "cat${count + 1}": "${_controller.text}",
        "No": FieldValue.increment(1)
      }).whenComplete(() {
        _getCat();
        setState(() {
          isAdded = false;
        });
        _controller.clear();
      });
    }
  }

  @override
  void initState() {
    _getCat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ),
        body: (isTapped)
            ? Center(child: SpinKitWave(color: Colors.black, size: 15.0))
            : ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  StreamBuilder(
                    stream: Firestore.instance
                        .collection("AdminControls")
                        .document("Categories")
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (!snapshots.hasData) {
                        return SpinKitWave(
                          color: Colors.indigo,
                          size: 15.0,
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshots.data["No"],
                          itemBuilder: (context, index) {
                            count = snapshots.data["No"];
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: 5.0,
                                  bottom: 5.0,
                                  left: 20.0,
                                  right: 20.0),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    gradient: LinearGradient(colors: [
                                      Color(0xFFf45d27),
                                      Color(0xFFf5851f)
                                    ])),
                                child: ListTile(
                                  dense: true,
                                  trailing: GestureDetector(
                                    child: Icon(Icons.delete),
                                    onTap: () {
                                      _name = snapshots.data["cat${index + 1}"];
                                      _shDialog(index);
                                    },
                                  ),
                                  title: Text(
                                      "${snapshots.data["cat${index + 1}"]}"),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _controller,
                        validator: (onValue) {
                          if (onValue.isEmpty) {
                            return "Category Name Needed";
                          }
                          if (lst.contains(onValue)) {
                            return "Name Already Exists";
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon: (isAdded)
                                ? SizedBox(
                                    width: 30.0,
                                    child: SpinKitWave(
                                      color: Colors.black,
                                      size: 13.0,
                                    ),
                                  )
                                : GestureDetector(
                                    child: Icon(Icons.add),
                                    onTap: () {
                                      _addCategory();
                                    },
                                  ),
                            hintText: "Add Category",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                      ),
                    ),
                  ),
                ],
              ));
  }
}
