import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_flutter2/pages/Message1.dart';
//import 'package:demo_flutter2/pages/Search.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
//import 'package:demo_flutter2/service/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:demo_flutter2/models/todo.dart';
import 'dart:async';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:demo_flutter2/pages/Message.dart';



class viewrideRequest extends StatelessWidget {
  viewrideRequest({this.v6});
  String v1;
  //final String v2;
  //final String v3;
  String v6;
   String v7;
  String v4;
  //String v9;
  var y1;
  //bool ans;
  int ans;
  
//Message ans1=new Message();
                             /* var firebase;
          var db = firebase.firestore();
      db.collection('offerride')
   .where('rideid',isEqualTo:v6)
   .update({
     'spot': '666',
   });*/

QuerySnapshot qn1;


DataSnapshot map;
  

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
                //Firestore.instance.collection('bookride').document(snapshot.data.documents.documentId).updateData({'spot':'100000000'});
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
                                      "name"]), // height: 50,                         color: Colors.amber[colorCodes[index]],
                             Text(snapshot
                                 .data.documents[index].data["gender"]),
                              Text(snapshot
                                  .data.documents[index].data["pickupaddress"]),
                              Text(snapshot
                                 .data.documents[index].data["dropaddress"]),
                              Text(snapshot.data.documents[index].data["pickuptime"]),
                              Text(snapshot.data.documents[index].data["spot"]),
                              //Text("vss"+v4),

                           // offerride()
                  
                      

                              // v6=Text('Source:'+snapshot.data.documents[index].data["source"]).toString();

                              /* Text(snapshot.data[index].data["source"]), // height: 50,                         color: Colors.amber[colorCodes[index]],
                                  Text(snapshot.data[index].data["destination"]),
                                   Text(snapshot.data[index].data["Arrivaltime"]),
                                    Text(snapshot.data[index].data["departuretime"]),
                                     Text(snapshot.data[index].data["date"]),
                                      Text(snapshot.data[index].data["spot"]),*/
                              // Text(snapshot.data[index].data["number"]),
                              //Text(snapshot.data.documents[index].documentId),
                              
                   
                                Row(
                               children:[
                        Expanded(
                              child:ButtonBar(
                                children: <Widget>[
                                  RaisedButton(
                                    child: const Text('Accept'),
                                    onPressed: () {

                               // print(snapshot.data.value);

                                     // updateDialog(context,snapshot.data.documents[index].documentId);
                                     
                                   // Firestore.instance.collection('offerride').document(v6).updateData({'spot':99999});
                                  //  qn1=Firestore.instance.collection('offerride').where('rideid',isEqualTo:v6);
                                    //qn1.data.documents[0].data["spot"].
                              //print(v6);
                              print(snapshot.data.documents[index].data["spot"].toString());
                                     Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => new Message(
                                              v9:v6,v10:snapshot.data.documents[index].data["spot"].toString(),
                                               )),
                                      );
                                      //print('ret data is $retData');
                                    },
                                  ),
                                ],
                              ),
                        ),

                          Expanded(
                              child:ButtonBar(
                                children: <Widget>[
                                  RaisedButton(
                                    child: const Text('Reject'),
                                    onPressed: () {
                                      
                                      //print('ret data is $retData');
                                    },
                                  ),
                                ],
                              ),
                        ),

                          ]
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
  Stream<QuerySnapshot> getAllCourses() {
    var firestore = Firestore.instance;
    //var firestore1 =firestore.collection('offerride').where('source',isEqualTo:v1).snapshots();
    Stream<QuerySnapshot> qn = firestore
        .collection('bookride')
        .where('rideid', isEqualTo: v6)
        .snapshots();
        

  return qn;


  }


}
