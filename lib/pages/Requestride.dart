import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:demo_flutter2/pages/Search.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
//import 'package:demo_flutter2/service/authentication.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:demo_flutter2/models/todo.dart';
import 'dart:async';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:demo_flutter2/pages/Message.dart';

/*class MystatefulWidget extends StatefulWidget
{
  MystatefulWidget({Key key}):super(key:key);
  @override

  _MystatefulWidgetState createState()=>_MystatefulWidgetState();
}*/
enum Gender{Male,Female}

class Example3 extends StatefulWidget {
  final String v6;
   final String v7;
  
  Example3({Key key,this.v6,this.v7}):super (key:key);
  
  @override
  State<StatefulWidget> createState() => Requestride();
  //State<StatefulWidget> createState1() => _ExampleState1();
}



class Requestride extends State<Example3> {
//var x=({this.v6});
Text x;
Text x1;
String _time = "PickUp Time";
TextEditingController _tx1 = new TextEditingController();
 TextEditingController _tx2 = new TextEditingController();
  TextEditingController _tx3 = new TextEditingController();
  TextEditingController _tx4 = new TextEditingController();
   String _ch='Male';
  int selectRadio;
 
 int g=1;
  //TextEditingController _tx1 = new TextEditingController();
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
                   // new Text("${widget.v6}"),
                     x=Text("${widget.v6}"), x1=Text("${widget.v7}"),
                    new Padding(
                        padding: EdgeInsets.only(top: 0.0, bottom: 0.0)),
                    new Container(
                      height: 150.0,
                      child: TextField(
                        controller: _tx1,
                        //onsubmit:_onsub,
                        // onChanged: (v) => _tx4.text = v,
                        maxLines: 4,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: "PickUp Address",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                      ),
                    ),

                     new Padding(
                        padding: EdgeInsets.only(top: 0.0, bottom: 0.0)),
                    new Container(
                      height: 150.0,
                      child: TextField(
                        controller: _tx2,
                        //onsubmit:_onsub,
                        // onChanged: (v) => _tx4.text = v,
                        maxLines: 4,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: "Dropping Address",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                      ),
                    ),
                     new Padding(
                        padding: EdgeInsets.only(top: 0.0, bottom: 0.0)),

                             SizedBox(
                      height: 0.0,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        DatePicker.showTimePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true, onConfirm: (time) {
                          print('confirm $time');
                          _time =
                              '${time.hour} : ${time.minute} : ${time.second}';
                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        size: 18.0,
                                        color: Colors.teal,
                                      ),
                                      Text(
                                        " $_time",
                                        style: TextStyle(
                                            color: Colors.teal,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "  Change",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ),

                     new Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 0.0)),
                    new Container(
                      height: 60.0,
                      child: TextField(
                        controller: _tx3,
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
                    
                     new Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 0.0)),
                      
                    new Container(
                      height: 60.0,
                      child: TextField(
                        controller: _tx4,
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

                   Row(
                      children:[
                        Expanded(
                             child: RadioListTile(
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: _ch,
                        
                         onChanged: (value){
                           setState(() {
                             _ch=value;
                           });
                         },
                        
                      ),
                          
                          ),
                          Expanded(
                            child: RadioListTile(
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: _ch,
                         onChanged: (value){
                           setState(() {
                             _ch=value;
                           });
                         },
                        
                      ),

                          ),
                      ]
                      

                   
                     /*new Container(
                      //height: 60.0,
                      child: RadioListTile<Gender>(
                        title: const Text('Female'),
                        value: Gender.Female,
                        groupValue: _ch,
                         onChanged: (Gender value){
                           setState(() {
                             _ch=value;
                           });
                         },
                        
                      ),

                      
                    ),*/
                    ),

                    
                    
                    new Padding(
                        padding: EdgeInsets.only(top: 30.0, bottom: 0.0)),
                    new Container(
                      width: 150.0,
                      height: 50.0,
                      child: RaisedButton(
                          onPressed: () {

                             Firestore.instance
                                .collection("bookride")
                                .document()
                                .setData({
                              'pickupaddress': _tx1.text,
                              'dropaddress': _tx2.text,
                              'pickuptime': _time,
                              'name': _tx3.text,
                              'age': _tx4.text,
                              'rideid':x.data,
                              'gender':_ch,
                              'spot':x1.data,
                              
                            });


                           // Firestore.instance
                             //   .collection("bookride").document().updateData()

                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new Message()),
                            );
                              
                             
                             

                 
                            
                            //print('ret data is $retData');
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