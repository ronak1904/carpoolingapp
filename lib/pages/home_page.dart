import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:demo_flutter2/service/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:demo_flutter2/models/todo.dart';
import 'dart:async';

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

  Query _todoQuery;

  //bool _isEmailVerified = false;

  @override
  void initState() {
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
  }

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
        body:new Container(
          
          padding: new EdgeInsets.only(left:100,right: 10,top: 140,bottom: 20),
          
          child: new Column(
            children: <Widget>[
              new SizedBox(
                width: 180,
              child: new RaisedButton(
                onPressed: (){ Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Example()),);},
                child: new Text('Offer A Ride', style: TextStyle(fontSize:15,height: 2)),
                
                color: Colors.blue,
                
              ),
              ),
              new SizedBox(
                width: 180,
              child: new RaisedButton(
                onPressed: (){},
                child: new Text('View A Rides Offered',style: TextStyle(fontSize:15,height:2)),
                color: Colors.blue,
              ),
               
              ),
               new SizedBox(
                width: 180,
               child:new RaisedButton(
                onPressed: (){},
                child: new Text('View Available Ride',style: TextStyle(fontSize:15,height: 2)),
                color: Colors.blue,
              ),
               ),
               new SizedBox(
                width: 185,
              child: new RaisedButton(
                onPressed: (){},
                child: new Text('View Rides Requested', style: TextStyle(fontSize:15,height: 2)),
                
                color: Colors.blue,
                
              ),
              ),
            ],
          ),
        ) ,
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
  //State<StatefulWidget> createState1() => _ExampleState1();
}




 class _SecondRoute extends State<Example> {
  var selected;
   final GlobalKey<FormState> formkey =new GlobalKey<FormState>();
   List<String> _source=<String>[
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
            padding: EdgeInsets.only(left: 2.0,right: 2.0),
            shrinkWrap: true,
            children: <Widget>[
               //Text('Source', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            SizedBox(height: 8.0,width: 40.0,),
            //padding: EdgeInsets.only(left: 2.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              
              //mainAxisAlignment: MainAxisAlignment.center,
              
              children: <Widget>[
                Text('Source',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                new Container(
                height: 48.0,
                width: 200.0,
        
              child:  
                   DropdownButton(
                    //labelText:Text('Source', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                   
                  items:_source.map((value)=>DropdownMenuItem(
                    
                    child: Text(
                      value,
                      
                    ),
                    value: value,
                  )).toList(),
                  onChanged: (selectSource)
                  {
                    setState(() {
                      selected=selectSource;   
                    });
                  },
                  value: selected,
                  isExpanded: false,
                  hint:Text('Select Source'),
                  //itemHeight: 10.0,
                 ),
                ),
                 Text('Destination',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
          new Container(
                 height: 48.0,
                 width: 200.0,
    
           child:DropdownButton(
                  
                  items:_source.map((value)=>DropdownMenuItem(
                    
                    child: Text(
                      value,
                      
                    ),
                    value: value,
                  )).toList(),
                  onChanged: (selectSource)
                  {
                    setState(() {
                      selected=selectSource;   
                    });
                  },
                  value: selected,
                  isExpanded: false,
                  hint:Text('Select Source'),
                 
                  //itemHeight: 10.0,
                 ),
              ),
             RaisedButton(
               child: Text('choose date and Time'),
               onPressed: (){
                 showDatePicker(
                   context: context,
                   initialDate: DateTime.now().add(Duration(seconds: 1)),
                   firstDate: DateTime.now(),
                   lastDate: DateTime(2100),
                 );
               },

              ),
              ],
            )
             
          
              
            ],
        )),
      ),
    );
  }
}


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

      
      