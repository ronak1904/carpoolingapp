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
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:demo_flutter2/service/authentication.dart';



class Message extends StatelessWidget {
  Auth obj = new Auth();
 var x=FirebaseAuth.instance.currentUser().then((obj)=>obj.uid.toString());
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: Text(x.toString()),
        
      ),
      body: new Container(
        child: Text('Your request has been processing'),
        
     
      ),
    );
}
}