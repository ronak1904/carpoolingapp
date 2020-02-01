import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:demo_flutter2/pages/Search.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
//import 'package:demo_flutter2/service/authentication.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:demo_flutter2/models/todo.dart';
import 'dart:async';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';




class Requestride extends StatelessWidget {

 Requestride({this.v6});
  int selectRadio;
 final String v6;
 int g=1;
  TextEditingController _tx1 = new TextEditingController();
   Widget build(BuildContext context) {
     
     return Scaffold(
      appBar: AppBar(
        title: Text("Request Ride"),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
            autovalidate: true,
            child: new ListView(
              padding: EdgeInsets.only(left: 2.0, right: 2.0),
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                  
                    new Container(
                      height: 60.0,
                      child: TextField(
                        controller: _tx1,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: " Name",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                      ),
                    ),
                      
                    new Container(
                      height: 60.0,
                      child: TextField(
                        controller: _tx1,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: "Age",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                      ),
                    ),
                    
                    new Padding(
                        padding: EdgeInsets.only(top: 30.0, bottom: 0.0)),
                    new Container(
                      width: 150.0,
                      height: 50.0,
                      child: RaisedButton(
                          onPressed: () {
                          },
                          child: new Text('Done',
                              style: TextStyle(
                                  fontSize: 20,
                                  height: 2,
                                  fontWeight: FontWeight.bold)),
                          color: Colors.blue,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0))),
                    ),
                    Radio(
                      value: 1,
                      groupValue: 1,
                      activeColor: Colors.green,
                      onChanged: (val)
                      {
                        print("Radio $val");
                      },
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}