import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddQues extends StatefulWidget {
  @override
  _AddQuesState createState() => _AddQuesState();
}

class _AddQuesState extends State<AddQues> {

  var _form = GlobalKey<FormState>();
  var _correct = '';
  int _numberQues = 1;
  TextEditingController ques = TextEditingController();
  List<TextEditingController> answers;
  bool isTapped = false;
  List<String> lst = [];
  bool hasList = false;

  _addQues() async {
    var details = Map<String, dynamic>();
    details["Q1"] = ques.text;
    details["Votes"] = 0;
    details["Category"] = _correct;
    for (int i = 0; i < _numberQues; i++) {
      details["A${i + 1}"] = answers[i].text;
      details["V${i + 1}"] = 0;
    }
    await Firestore.instance
        .collection("Poll Questions")
        .add(details)
        .whenComplete(() {
      setState(() {
        isTapped = false;
      });
      Navigator.of(context).pop();
    });
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
    _correct = lst[0];
    setState(() {
      hasList = true;
    });
  }

  @override
  void initState() {
    _getCategories();
    answers =
        List.generate(_numberQues, (context) => new TextEditingController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
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
            "Add Question",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Form(
          key: _form,
          child: Padding(
            padding: EdgeInsets.all(17.0),
            child: ListView(
              children: <Widget>[
                Text(
                  'Question',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 25.0),
                  child: TextFormField(
                    style: textStyle,
                    controller: ques,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Invalid Input';
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontSize: 15.0,
                      ),
                      hintStyle: TextStyle(fontSize: 14.0),
                      hintText: 'Please enter a question',
                      labelStyle: textStyle,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _numberQues,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Option ${index + 1}.",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          style: textStyle,
                          controller: answers[index],
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Invalid Input';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              fontSize: 15.0,
                            ),
                            labelStyle: textStyle,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        )
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _numberQues = _numberQues + 1;
                          answers.add(TextEditingController());
                        });
                      },
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    RaisedButton(
                      child: Icon(Icons.remove),
                      onPressed: () {
                        if (_numberQues > 1) {
                          setState(() {
                            _numberQues = _numberQues - 1;
                            answers.removeLast();
                          });
                        }
                      },
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0, bottom: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Category Of Event",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 23.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
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
                                  });
                                },
                              )
                            : SizedBox(),
                      )
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      //color: Color(0XFF71D59D),
                      onPressed: (isTapped)
                          ? () {}
                          : () {
                              if (_form.currentState.validate()) {
                                print("okay");
                                setState(() {
                                  isTapped = true;
                                });
                                _addQues();
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
                                width: 20.0,
                                child: SpinKitWave(
                                  color: Colors.black,
                                  size: 13.0,
                                ),
                              )
                            : Text(
                                'Save',
                              ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
