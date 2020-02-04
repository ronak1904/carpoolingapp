import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_flutter2/pages/Message1.dart';
//import 'package:demo_flutter2/pages/Search.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:demo_flutter2/service/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:demo_flutter2/models/todo.dart';
import 'dart:async';
import 'package:demo_flutter2/service/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:demo_flutter2/service/authentication.dart';



class Message extends StatelessWidget {
 // Auth obj = new Auth();
 String v9,v10;
 int ans=0;
  Message({this.v9,this.v10});
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
                  
//                     padding: const EdgeInsets.all(8),
                      
                        
                            
                                
                        //Text(snapshot.data.documents[index].data["spot"].toString());
                            // mainAxisSize: MainAxisSize.min,
                          print('jdj');
                             
                          print(snapshot.data.documents[0].data["spot"].toString());
                          print(num.parse(v10).toString());
                         // print(ans);
                         print(v10);
                         ans=int.parse(snapshot.data.documents[0].data["spot"].toString())-int.parse(v10);
                  //print(ans);
                     Firestore.instance.collection('offerride').document(v9).updateData({'spot':ans.toString()});
                        
                    Text("ths");
                              // v6=Text('Source:'+snapshot.data.documents[index].data["source"]).toString();

                    
                        
                      
                }
              })),
    );
}

 Stream<QuerySnapshot> getAllCourses() {
    var firestore = Firestore.instance;
    print("hello");
    //var firestore1 =firestore.collection('offerride').where('source',isEqualTo:v1).snapshots();
    Stream<QuerySnapshot> qn = firestore
        .collection('offerride')
        .where('rideid', isEqualTo: v9)
        .snapshots();
     

  return qn;


  }





}