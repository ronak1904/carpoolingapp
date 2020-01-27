import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:demo_flutter2/pages/Search.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
//import 'package:demo_flutter2/service/authentication.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:demo_flutter2/models/todo.dart';
import 'dart:async';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';



class Passscreen extends StatelessWidget {
  Passscreen({this.v1, this.v2, this.v3});
  String v1;
  final String v2;
  final String v3;
  //bool ans;
  int ans;
  /*Widget show(int index)
  {
     builder: (_, snapshot) 
     {
          return Container(
                              child: Card(
                                child:InkWell(
                                  onTap: () {
                                    //
                 

                                        },

                            child: Column(
                             // mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                             
                             // (snapshot.data[index].data["source"].toString()==v1)? ans=1:null,
                                
                                  Text(snapshot.data[index].data["source"]), // height: 50,                         color: Colors.amber[colorCodes[index]],
                                  Text(snapshot.data[index].data["destination"]),
                                   Text(snapshot.data[index].data["Arrivaltime"]),
                                   Text(snapshot.data[index].data["departuretime"]),
                                  Text(snapshot.data[index].data["date"]),
                                     Text(snapshot.data[index].data["spot"]),
                                    // Text(snapshot.data[index].data["number"]),
                                
                                ButtonBar(
                                    children: <Widget>[
                                     
                                      RaisedButton(
                                        child: const Text('Book A Ride'),
                                        onPressed: () {
                                                  //final Course course= Course( courseName : (snapshot.data[index].data["name"]).toString(),courseDescription : snapshot.data[index].data["description"],courseImage :snapshot.data[index].data["imageurl"],courseOverView:snapshot.data[index].data["courseOverView"]);
                        //  debugPrint("Hello"+snapshot.data[index].data["courseOverView"]);
                                          
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => CourseDetail(course : course,),
              //     // Pass the arguments as part of the RouteSettings. The
              //     // DetailScreen reads the arguments from these settings.
              
              //   ),
              // 
            //  );
            

                                        },
                                      ),
                                    ],
                                    alignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max),
                              ],
                          
                            ),
                          
                          )
       
                           ) );
     };
  }*/
   Stream<QuerySnapshot> getAllCourses(){
    var firestore = Firestore.instance;
     //var firestore1 =firestore.collection('offerride').where('source',isEqualTo:v1).snapshots();
    Stream<QuerySnapshot> qn =   firestore.collection('offerride').where('source',isEqualTo:v1).where('destination',isEqualTo:'Bhavnagar').snapshots();
   // QuerySnapshot qn1=qn.isBroadcast();
    return qn;
   

    

  }
  @override
  Widget build(BuildContext context) {
    return Container(


            
              child:StreamBuilder(
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
                                child:InkWell(
                                  onTap: () {
                                    //
                 

                                        },

                            child: Column(
                             // mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                            // Text(snapshot.data[index].data["source"]),
                            // (snapshot.data[index].data["source"].toString()==v1)? show(index):null,
                            //if(snapshot.data[index].data["sourece"].toString()==v1)
                             
                              Text('Source:'+snapshot.data.documents[index].data["source"]), // height: 50,                         color: Colors.amber[colorCodes[index]],
                                Text(snapshot.data.documents[index].data["destination"]),
                                  Text(snapshot.data.documents[index].data["Arrivaltime"]),
                                   Text(snapshot.data.documents[index].data["departuretime"]),
                                     Text(snapshot.data.documents[index].data["date"]),
                                      Text(snapshot.data.documents[index].data["spot"]),
                                   
                             
                                
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
                                       onPressed: () {},
              
              
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
                          
                          )
       
                           ) );
                        });
                  }
                }));
  }
}
