import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:demo_flutter2/pages/Search.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
//import 'package:demo_flutter2/service/authentication.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:demo_flutter2/models/todo.dart';
import 'dart:async';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:demo_flutter2/pages/Requestride.dart';

class Passscreen extends StatelessWidget {
  Passscreen({this.v1, this.v2, this.v3, this.v4});
  String v1;
  final String v2;
  final String v3;
  String v6;
   String v7;
  int v4;
  int v4x;
  //bool ans;
  int ans;

  Stream<QuerySnapshot> getAllCourses() {
    //v4x=int.parse(v4);
    var firestore = Firestore.instance;
    //var firestore1 =firestore.collection('offerride').where('source',isEqualTo:v1).snapshots();
    Stream<QuerySnapshot> qn = firestore
        .collection('offerride')
        .where('source', isEqualTo: v1)
        .where('destination', isEqualTo: v2)
        .where('date', isEqualTo: v3)
        .where('spot', isGreaterThanOrEqualTo: v4)
        .snapshots();
    //Stream<QuerySnapshot> qn1 =   firestore.collection('offerride').where(field).snapshots();

    // QuerySnapshot qn1=qn.isBroadcast();
    return qn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Ride"),
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
                              // Text(snapshot.data[index].data["source"]),
                              // (snapshot.data[index].data["source"].toString()==v1)? show(index):null,
                              //if(snapshot.data[index].data["sourece"].toString()==v1)

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
                              Text(snapshot.data.documents[index].data["spot"].toString()),
                              //Text("vss"+v4),

                              // v6=Text('Source:'+snapshot.data.documents[index].data["source"]).toString();

                              /* Text(snapshot.data[index].data["source"]), // height: 50,                         color: Colors.amber[colorCodes[index]],
                                  Text(snapshot.data[index].data["destination"]),
                                   Text(snapshot.data[index].data["Arrivaltime"]),
                                    Text(snapshot.data[index].data["departuretime"]),
                                     Text(snapshot.data[index].data["date"]),
                                      Text(snapshot.data[index].data["spot"]),*/
                              // Text(snapshot.data[index].data["number"]),

                              ButtonBar(
                                children: <Widget>[
                                  RaisedButton(
                                    child: const Text('Book A Ride'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => new Example3(
                                                v6: snapshot
                                                    .data
                                                    .documents[index]
                                                    .data["rideid"]
                                                    .toString(),v7:v4)),
                                      );
                                      //print('ret data is $retData');
                                    },
                                  ),
                                ],
                              ),

                              //             },
                              //         ),
                              //     ],
                              // alignment: MainAxisAlignment.center,
                              //mainAxisSize: MainAxisSize.max),
                            ],
                          ),
                        )));
                      });
                }
              })),
    );
  }
}
