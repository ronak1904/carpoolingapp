import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:demo_flutter2/pages/Search.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:demo_flutter2/service/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:demo_flutter2/models/todo.dart';
import 'dart:async';
import 'package:demo_flutter2/service/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo_flutter2/pages/viewriderequest.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

//import 'package:demo_flutter2/service/authentication.dart';

String _userId;

class viewrideoffer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation message'),
      ),
      body: new Container(
          child: StreamBuilder(
              stream: getAllCourses(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text("loading..."),
                  );
                } else {
                  return ListView.builder(
//                     padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (_, index) {
                        return Container(
                            child: Card(
                                child: InkWell(
                          onTap: () {
                            //
                          },
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                        

                              Text('Source:' +
                                  snapshot.data.documents[index].data[
                                      "source"]), // height: 50,                         color: Colors.amber[colorCodes[index]],
                              Text(snapshot
                                  .data.documents[index].data["destination"]),
                              Text(snapshot
                                  .data.documents[index].data["Arrivaltime"]),
                              Text(snapshot
                                  .data.documents[index].data["departuretime"]),
                              Text(snapshot.data.documents[index].data["date"]),
                              Text(snapshot.data.documents[index].data["spot"]),
                             
                              ButtonBar(
                                children: <Widget>[
                                  RaisedButton(
                                    child: const Text('View ride Request'),
                                    onPressed: () {
                                      //print('ret data is $retData');
                                       Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => new viewrideRequest(
                                                v6: snapshot
                                                    .data
                                                    .documents[index]
                                                    .data["rideid"]
                                                    .toString())),
                                      );
                                    },
                                  ),
                                ],
                              ),

                            ],
                          ),
                        )));
                      });
                }
              })),
    );
  }

  Stream<QuerySnapshot> getAllCourses() {
    FirebaseAuth.instance.currentUser().then((user) {
      _userId = user.uid;
      //print(_userId);
    });
    // print(_userId);
    var firestore = Firestore.instance;
    //var firestore1 =firestore.collection('offerride').where('source',isEqualTo:v1).snapshots();
    Stream<QuerySnapshot> qn = firestore
        .collection('offerride')
        .where('userid', isEqualTo: _userId)
        .snapshots();
    //Stream<QuerySnapshot> qn1 =   firestore.collection('offerride').where(field).snapshots();
        
    // QuerySnapshot qn1=qn.isBroadcast();
    return qn;
  }
}
