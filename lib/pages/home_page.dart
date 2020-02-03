import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_flutter2/pages/Message.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:demo_flutter2/service/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:demo_flutter2/models/todo.dart';
import 'dart:async';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:demo_flutter2/pages/Passscreen.dart';
import 'package:demo_flutter2/pages/Message1.dart';

import 'package:demo_flutter2/pages/viewrideoffer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> _todoList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  //Query _todoQuery;

  //bool _isEmailVerified = false;

  @override
  /*void initState() {
    super.initState();

    //_checkEmailVerification();

    _todoList = new List();
    _todoQuery = _database
        .reference()
        .child("todo")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(onEntryAdded);
    _onTodoChangedSubscription =
        _todoQuery.onChildChanged.listen(onEntryChanged);
  }*/

//  void _checkEmailVerification() async {
//    _isEmailVerified = await widget.auth.isEmailVerified();
//    if (!_isEmailVerified) {
//      _showVerifyEmailDialog();
//    }
//  }

//  void _resentVerifyEmail(){
//    widget.auth.sendEmailVerification();
//    _showVerifyEmailSentDialog();
//  }

//  void _showVerifyEmailDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content: new Text("Please verify account in the link sent to email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Resent link"),
//              onPressed: () {
//                Navigator.of(context).pop();
//                _resentVerifyEmail();
//              },
//            ),
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content: new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _todoList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _todoList[_todoList.indexOf(oldEntry)] =
          Todo.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _todoList.add(Todo.fromSnapshot(event.snapshot));
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  addNewTodo(String todoItem) {
    if (todoItem.length > 0) {
      Todo todo = new Todo(todoItem.toString(), widget.userId, false);
      _database.reference().child("todo").push().set(todo.toJson());
    }
  }

  updateTodo(Todo todo) {
    //Toggle completed
    todo.completed = !todo.completed;
    if (todo != null) {
      _database.reference().child("todo").child(todo.key).set(todo.toJson());
    }
  }

  deleteTodo(String todoId, int index) {
    _database.reference().child("todo").child(todoId).remove().then((_) {
      print("Delete $todoId successful");
      setState(() {
        _todoList.removeAt(index);
      });
    });
  }

  showAddTodoDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Add new todo',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    addNewTodo(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Widget showTodoList() {
    if (_todoList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _todoList.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = _todoList[index].key;
            String subject = _todoList[index].subject;
            bool completed = _todoList[index].completed;
            //String userId = _todoList[index].userId;
            return Dismissible(
              key: Key(todoId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                deleteTodo(todoId, index);
              },
              child: ListTile(
                title: Text(
                  subject,
                  style: TextStyle(fontSize: 20.0),
                ),
                trailing: IconButton(
                    icon: (completed)
                        ? Icon(
                            Icons.done_outline,
                            color: Colors.green,
                            size: 20.0,
                          )
                        : Icon(Icons.done, color: Colors.grey, size: 20.0),
                    onPressed: () {
                      updateTodo(_todoList[index]);
                    }),
              ),
            );
          });
    } else {
      return Center(
          child: Text(
        "Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }

/* String out;
  GetSharedVariables() async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    out=prefs.getString('uid');
  }
*/
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter login demo'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
        body: new Container(
           
          padding:
              new EdgeInsets.only(left: 100, right: 10, top: 140, bottom: 20),
          child: new Column(
            children: <Widget>[
              new SizedBox(
                width: 180,
                child: new RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Example()),
                    );
                  },
                  child: new Text('Offer A Ride',
                      style: TextStyle(fontSize: 15, height: 2)),
                  color: Colors.blue,
                ),
              ),
              new SizedBox(
                width: 180,
                child: new RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Example1()),
                    );
                  },
                  child: new Text('View Available Ride ',
                      style: TextStyle(fontSize: 15, height: 2)),
                  color: Colors.blue,
                ),
              ),
              new SizedBox(
                width: 180,
                child: new RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new viewrideoffer()),
                    );
                  },
                  child: new Text('View A Rides Offered',
                      style: TextStyle(fontSize: 15, height: 2)),
                  color: Colors.blue,
                ),
              ),
              new SizedBox(
                width: 185,
                child: new RaisedButton(
                  onPressed: () {},
                  child: new Text('View Rides Requested',
                      style: TextStyle(fontSize: 15, height: 2)),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        // showTodoList(),

        /*         new SizedBox(
                   width: 200.0,
   height: 100.0,
  child: new RaisedButton(
    child: new Text('Blabla blablablablablablabla bla bla bla'),
    onPressed: (){},
  ),
),*/

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddTodoDialog(context);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }
}

class Example extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SecondRoute();
  //State<StatefulWidget> createState() => _SecondRoute1();
  //State<StatefulWidget> createState1() => _ExampleState1();
}

class _SecondRoute extends State<Example> {
  var selected;
  var selected1;

  static int myid = 1;
  String _date = "Date";
  String _time = "Arrival Time";
  String _time1 = "Departure Time";

  TextEditingController _tx1 = new TextEditingController();
  TextEditingController _tx2 = new TextEditingController();
  TextEditingController _tx3 = new TextEditingController();
  TextEditingController _tx4 = new TextEditingController();
  String _userId;
  final GlobalKey<FormState> formkey = new GlobalKey<FormState>();
  List<String> _source = <String>[
    'Ahmedabad',
    'Surat',
    'Bhavnagar',
    'Gandhinagar',
  ];
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((user) {
      _userId = user.uid;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
            key: formkey,
            autovalidate: true,
            child: new ListView(
              padding: EdgeInsets.only(left: 2.0, right: 2.0),
              shrinkWrap: true,
              children: <Widget>[
                //Text('Source', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(
                  height: 8.0,
                  width: 40.0,
                ),
                //padding: EdgeInsets.only(left: 2.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  //mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    Text(
                      'Source',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    new Container(
                      height: 48.0,
                      width: 200.0,
                      child: DropdownButton(
                        //labelText:Text('Source', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                        items: _source
                            .map((value) => DropdownMenuItem(
                                  child: Text(
                                    value,
                                  ),
                                  value: value,
                                ))
                            .toList(),
                        onChanged: (selectSource) {
                          setState(() {
                            selected = selectSource;
                          });
                        },
                        value: selected,
                        isExpanded: false,
                        hint: Text('Select Source'),
                        //itemHeight: 10.0,
                      ),
                    ),
                    Text(
                      'Destination',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    new Container(
                      height: 48.0,
                      width: 200.0,
                      child: DropdownButton(
                        items: _source
                            .map((value) => DropdownMenuItem(
                                  child: Text(
                                    value,
                                  ),
                                  value: value,
                                ))
                            .toList(),
                        onChanged: (selectSource) {
                          setState(() {
                            selected1 = selectSource;
                          });
                        },
                        value: selected1,
                        isExpanded: false,
                        hint: Text('Select Destination'),

                        //itemHeight: 10.0,
                      ),
                    ),
                    /* RaisedButton(
               child: Text('choose date and Time'),
               onPressed: (){
                 showDatePicker(
                   context: context,
                   initialDate: DateTime.now().add(Duration(seconds: 1)),
                   firstDate: DateTime.now(),
                   lastDate: DateTime(2100),
                 );
               },

              ),*/

                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true,
                            minTime: DateTime(2000, 1, 1),
                            maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                          print('confirm $date');
                          _date = '${date.year} - ${date.month} - ${date.day}';
                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
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
                                        Icons.date_range,
                                        size: 18.0,
                                        color: Colors.teal,
                                      ),
                                      Text(
                                        " $_date",
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
                    SizedBox(
                      height: 20.0,
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
                    SizedBox(
                      height: 20.0,
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
                          _time1 =
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
                                        " $_time1",
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
                    new Padding(padding: EdgeInsets.only(top: 20.0)),
                    new Container(
                      height: 60.0,
                      child: TextField(
                        controller: _tx1,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: "Free Spote",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 20.0)),
                    new Container(
                      height: 60.0,
                      child: TextField(
                        controller: _tx2,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: "Cost Per Km",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 20.0)),
                    new Container(
                      height: 60.0,
                      child: TextField(
                        controller: _tx3,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: "Vehicle Number",
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
                      height: 190.0,
                      child: TextField(
                        controller: _tx4,
                        //onsubmit:_onsub,
                        // onChanged: (v) => _tx4.text = v,
                        maxLines: 4,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: "Vehicle Description",
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
                      width: 150.0,
                      height: 50.0,
                      //new Padding(padding: EdgeInsets.only(top: 20.0)),
                      // margin: EdgeInsets.only(top:0.0),
                      //padding: EdgeInsets.only(top: 0.0),

                      child: RaisedButton(
                          onPressed: () {
                            Firestore.instance
                                .collection("offerride")
                                .document()
                                .setData({
                              'source': selected,
                              'destination': selected1,
                              'date': _date,
                              'Arrivaltime': _time,
                              'departuretime': _time1,
                              'spot': _tx1.text,
                              'cost': _tx2.text,
                              'number': _tx3.text,
                              'description': _tx4.text,
                              'rideid': new DateTime.now().microsecondsSinceEpoch,
                              'userid': _userId,
                            });
                            myid++;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new Message1()),
                            );
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
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class Example1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Second();
  //State<StatefulWidget> createState1() => _ExampleState1();
}

class _Second extends State<Example1> {
  var selected;
  var selected1;
  var v1;
  var v4;
  String v2;
  String v3;
  TextEditingController _tx5 = new TextEditingController();
  String _date = "Date";
  String _time = "Arrival Time";
  String _time1 = "Departure Time";

  final GlobalKey<FormState> formkey = new GlobalKey<FormState>();
  List<String> _source = <String>[
    'Ahmedabad',
    'Surat',
    'Bhavnagar',
    'Gandhinagar',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
            key: formkey,
            autovalidate: true,
            child: new ListView(
              padding: EdgeInsets.only(left: 2.0, right: 2.0),
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Source',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    new Container(
                      height: 48.0,
                      width: 200.0,
                      child: DropdownButton(
                        //labelText:Text('Source', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                        items: _source
                            .map((value) => DropdownMenuItem(
                                  child: Text(
                                    value,
                                  ),
                                  value: value,
                                ))
                            .toList(),
                        onChanged: (selectSource) {
                          setState(() {
                            selected = selectSource;
                          });
                        },
                        value: selected,
                        isExpanded: false,
                        hint: Text('Select Source'),
                        //itemHeight: 10.0,
                      ),
                    ),
                    new Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 0.0)),
                    Text(
                      'Destination',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    new Container(
                      height: 48.0,
                      width: 200.0,
                      child: DropdownButton(
                        items: _source
                            .map((value) => DropdownMenuItem(
                                  child: Text(
                                    value,
                                  ),
                                  value: value,
                                ))
                            .toList(),
                        onChanged: (selectSource) {
                          setState(() {
                            selected1 = selectSource;
                          });
                        },
                        value: selected1,
                        isExpanded: false,
                        hint: Text('Select Destination'),

                        //itemHeight: 10.0,
                      ),
                    ),
                    new Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 0.0)),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true,
                            minTime: DateTime(2000, 1, 1),
                            maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                          print('confirm $date');
                          _date = '${date.year} - ${date.month} - ${date.day}';
                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
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
                                        Icons.date_range,
                                        size: 18.0,
                                        color: Colors.teal,
                                      ),
                                      Text(
                                        " $_date",
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
                    new Padding(padding: EdgeInsets.only(top: 20.0)),
                    new Container(
                      height: 60.0,
                      child: TextField(
                        controller: _tx5,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: " No of Seat",
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
                      //new Padding(padding: EdgeInsets.only(top: 20.0)),
                      // margin: EdgeInsets.only(top:0.0),
                      //padding: EdgeInsets.only(top: 0.0),
                      child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new Passscreen(
                                      v1: selected,
                                      v2: selected1,
                                      v3: _date,
                                      v4: _tx5.text)),
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
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

/*class Passscreen extends StatelessWidget {
  List<Search> postList =[];
  void initState()
  {
    super.initState();
  }
  Passscreen({this.v1, this.v2, this.v3});
  final databaseReference = FirebaseDatabase.instance.reference();
  final String v1;
  final String v2;
  final String v3;
  var x;
  var y;
  var z;
  var y1;
   var y2;
    var y3;
     var y4;
      var y5;
       var y6;
        var y7;
         var y8;
  //TextEditingController _tx4 = new TextEditingController();
// String x;
  @override
  Widget build(BuildContext context) {
    //getData();
    // y=(snapshot.data.documents[9]['source'].toString()),
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Route"),
        ),
        body:
         StreamBuilder(
          stream: Firestore.instance.collection('offerride').snapshots(),
          
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('Lodding data');
            } else {
             // for(int i=0;i<10;i++)
              //{
                int i=9;
                var key=snapshot.hasData.;
                for(var x in len(key))
                {

                }
              x = (v1.toString());
              print(x);
              y = (snapshot.data.documents[i]['source'].toString());
              //x=y.toString(),
               print(y);

              // z=y.compareTo(x),

              //Text(snapshot.data.documents[9]['destination']),
              
              if (x==y) {
                y1 = (snapshot.data.documents[i]['destination'].toString());
                 y2 = (snapshot.data.documents[i]['Arrivaltime'].toString());
                  y3 = (snapshot.data.documents[i]['departuretime'].toString());
                   y4 = (snapshot.data.documents[i]['date'].toString());
                    y5 = (snapshot.data.documents[i]['cost'].toString());
                     y6 = (snapshot.data.documents[i]['description'].toString());
                      y7 = (snapshot.data.documents[i]['spot'].toString());
                      y8 = (snapshot.data.documents[i]['number'].toString());
               
              }
              //new Text('jk');  
              //new Text('Source:'+y);
              return Column(children: <Widget>[Text('Source:'+y),Text('Destination:'+y1),Text('Arrivaltime:'+y2),
                                                   Text('Departuretime'+y3),Text('Date:'+y4),Text('Cost:'+y5),Text('Description:'+y6),
                                                    Text('Spot:'+y7),Text('Number:'+y8)],);
              
              
              //return Container(width: 0.0, height: 0.0);
            }
            //}
          },
        )
        //new Text(v1),
        //new Text(v2),
        //new Text(v3),

        );
  }
}*/

/*class Passscreen extends StatelessWidget {
  Passscreen({this.v1, this.v2, this.v3});
   final String v1;
  final String v2;
  final String v3;
  Future getAllCourses() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('offerride').getDocuments();
    return qn.documents;
  }
  @override
  Widget build(BuildContext context) {
    return Container(


            child: FutureBuilder(
                future: getAllCourses(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("loading..."),
                    );
                  } else {
                    return ListView.builder(
//                     padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return Container(
                              child: Card(
                                child:InkWell(
                                  onTap: () {
                                    //
                 

                                        },

                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Image.network(
                                    snapshot.data[index].data[""]),
                                
                                ListTile(
                                  title: Text(snapshot.data[index].data[
                                      "name"]), // height: 50,                         color: Colors.amber[colorCodes[index]],
                                  subtitle: Text(
                                      snapshot.data[index].data["description"]),
                                ),
                                ButtonBar(
                                    children: <Widget>[
                                     
                                      RaisedButton(
                                        child: const Text('DETAILS'),
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
                        });
                  }
                }));
  }
}*/

/*String dropdownValue = 'Ahmedabad';
class _ExampleState extends State<Example> {
  Widget build(BuildContext context) {
    
  return DropdownButton<String>(
    value: dropdownValue,
    icon: Icon(Icons.arrow_downward),
    iconSize: 24,
    elevation: 16,
    style: TextStyle(
      color: Colors.deepPurple
    ),
    underline: Container(
      height: 2,
      color: Colors.deepPurpleAccent,
    ),
    onChanged: (String newValue) {
      setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['Ahmedabad', 'Surat', 'Gandhinagar', 'Bhavnagar']
            .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
            .toList(),
        );
  }
}

String dropdownValue1 = 'Ahmedabad';
class _ExampleState1 extends State<Example> {
  Widget build(BuildContext context) {
    
  return DropdownButton<String>(
    value: dropdownValue1,
    icon: Icon(Icons.arrow_downward),
    iconSize: 24,
    elevation: 16,
    style: TextStyle(
      color: Colors.deepPurple
    ),
    underline: Container(
      height: 2,
      color: Colors.deepPurpleAccent,
    ),
    onChanged: (String newValue) {
      setState(() {
              dropdownValue1 = newValue;
            });
          },
          items: <String>['Ahmedabad', 'Surat', 'Gandhinagar', 'Bhavnagar']
            .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
            .toList(),
        );
  }
}*/

/*String dropdownValue = 'One';
Widget showEmailInput(){

  return DropdownButton<String>(
    value: dropdownValue,
    icon: Icon(Icons.arrow_downward),
    iconSize: 24,
    elevation: 16,
    style: TextStyle(
      color: Colors.deepPurple
    ),
    underline: Container(
      height: 2,
      color: Colors.deepPurpleAccent,
    ),
    onChanged: (String newValue) {
      setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['One', 'Two', 'Free', 'Four']
            .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
            .toList(),
        );
      }

      */

// @protected

//void setState(() { _myState = newValue });
