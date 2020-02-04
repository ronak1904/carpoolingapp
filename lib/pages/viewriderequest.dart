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
  Text offspot;
  int ioffspot;
  int bookspot;
  int finalans;
  String myrequestid;
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
      body:
      Column(children: <Widget>[
Expanded(
 child: Container(
          child:StreamBuilder(
              stream: getAllCourses(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text("loading..."),
                  );
                } else {
                  return ListView.builder(
      itemCount: snapshot.data.documents.length,
                      itemBuilder: (_, index) {
                        //bookspot=snapshot.data.documents[index].data["spot"];
                        //myrequestid=snapshot.data.documents[index].data["spot"];
                        return Container(
                            child: Card(
                                child: InkWell(
                          onTap: () {
                },
                          child: Column(
                            children: <Widget>[
                              
                              Text('Source:' +
                                  snapshot.data.documents[index].data[
                                      "name"]),
                             Text(snapshot
                                 .data.documents[index].data["gender"]),
                              Text(snapshot
                                  .data.documents[index].data["pickupaddress"]),
                              Text(snapshot
                                 .data.documents[index].data["dropaddress"]),
                              Text(snapshot.data.documents[index].data["pickuptime"]),
                              Text(snapshot.data.documents[index].data["spot"].toString()),
                              //Text("boo="+bookspot),                              
                          
                                Row(
                               children:[
                        Expanded(
                              child:ButtonBar(
                                children: <Widget>[
                                  RaisedButton(
                                    child: const Text('Accept'),
                                    onPressed: () {
                                      bookspot=snapshot.data.documents[index].data["spot"];
                                      myrequestid=snapshot.data.documents[index].data["requestid"];
                                      print(myrequestid);
                                       finalans=ioffspot-bookspot;
                                       Firestore.instance.collection('offerride').document(v6).updateData({'spot':finalans});
                                       Firestore.instance.collection('bookride').document(myrequestid).updateData({'status':'accepted'});
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
                                      myrequestid=snapshot.data.documents[index].data["requestid"];
                                      Firestore.instance.collection('bookride').document(myrequestid).updateData({'status':'rejected'});
                                    },
                                  ),
                                ],
                              ),
                        ),

                          ]
                                ),

                            ],
                          ),
                        )));
                      });
                }
              }),
)),
              
              Expanded(child:
                Container(
                  child:   StreamBuilder(
              stream: getAllOffers(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text("loading..."),
                  );
                } else {
                  return ListView.builder(
      itemCount: snapshot.data.documents.length,
                      itemBuilder: (_, index) {
                        ioffspot=snapshot.data.documents[index].data["spot"];
                        return Container(
                            child: Card(
                                child: InkWell(
                          onTap: () {
                },
                
                          child: Column(
                            
                            children: <Widget>[
                              
                        


                              //offspot=(Text(snapshot.data.documents[index].data["spot"].toString())),                              
                              //Text(ioffspot),
          
                              //ioffspot=snapshot.data.documents[index].data["spot"].toString(),

                            ],
                          ),
                        )));
                      });
                }
              })     
              


                ))

      ],)
      
      
    );
    
  }
  Stream<QuerySnapshot> getAllCourses() {
    var firestore = Firestore.instance;
    Stream<QuerySnapshot> qn = firestore
        .collection('bookride')
        .where('rideid', isEqualTo: v6).where('status', isEqualTo: 'pending')
        .snapshots();
  return qn;
  }

  Stream<QuerySnapshot> getAllOffers()
   {
    var firestore = Firestore.instance;
    Stream<QuerySnapshot> qn = firestore
        .collection('offerride')
        .where('rideid', isEqualTo: v6)
        .snapshots();
    return qn;
  }
/*void myofer(QuerySnapshot snapshot)
{
  snapshot.documents.where('spot', isGreaterThanOrEqualTo:5);
}
*/
}
