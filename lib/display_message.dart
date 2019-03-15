import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebaseapp/myComment.dart';
import 'package:time_machine/time_machine.dart';

class displaymessage extends StatefulWidget {
  @override
  _displaymessageState createState() => _displaymessageState();
}

Future<String> getname() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String name = preferences.getString('message_name');
  print('$name');
  return name;
}

Future<String> getmessage() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String message = preferences.getString('message');
  return message;
}

Future<String> getmessage_imageurl() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = prefs.getString('message_image');
  print('$url');
  return url;
}

Future<String> get_message_timestamp() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String timestamp = preferences.getString('message_timestamp');
  return timestamp;
}

Future<String> get_sendername() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String name = preferences.getString('name');
  return name;
}

Future<String> get_senderimageurl() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String name = preferences.getString('image');
  return name;
}

class _displaymessageState extends State<displaymessage> {
  bool display_textbox = false;
  bool _display_comment = false;

  List<myComment> allData = [];

  var _newname = '';
  var _newurl = '';
  var _newmessage = '';
  var _newmessagetimestamp;

  var _sendername = '';
  var _senderimageurl = '';

  var _message;
  final formKey = new GlobalKey<FormState>();

  DatabaseReference ref = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState

    getmessage().then(updatemessage);
    getmessage_imageurl().then(updateurl);
    getname().then(updatename);
    get_message_timestamp().then(updatemessage_timestamp);
    get_senderimageurl().then(update_senderimageurl);
    get_sendername().then(update_sendername);

    setState(() {});

    _comments();

    super.initState();
  }

  Future<String> _comments() async {
    await new Future.delayed(new Duration(milliseconds: 100), () {
      ref
          .child('node-name')
          .child('$_newmessagetimestamp')
          .child('comments')
          .once()
          .then(
        (DataSnapshot snap) {
          var keys = snap.value.keys;
          var data = snap.value;

          List list = [];

          for (var key in keys) {
            print('this is keys :$key');
            if (key != 'no-comments') {
              list.add(key);
              list.sort();
            } else if (key == 'no-comments') {
              print('its found :$key');
            }
          }

          var reversed = list.reversed;

          for (var newlist in reversed) {
            myComment d = new myComment(
              data[newlist]['name'],
              data[newlist]['comment'],
              data[newlist]['image_url'],
            );
            allData.add(d);
          }
          setState(() {});
        },
      );
    });
  }



//  var timestamp = new DateTime.now().millisecondsSinceEpoch;

  void submit_comment() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      print('this is message :$_message');
      submit_comment_database();
    }
  }

  void submit_comment_database() {
    var now = Instant.now();
    var timestamp = now.toString('yyyyMMddHHmmss');

    print('this is comments timestamp :$timestamp');

    ref
        .child('node-name')
        .child('$_newmessagetimestamp')
        .child('comments')
        .child('$timestamp')
        .child('comment')
        .set('$_message');
    ref
        .child('node-name')
        .child('$_newmessagetimestamp')
        .child('comments')
        .child('$timestamp')
        .child('image_url')
        .set('$_senderimageurl');
    ref
        .child('node-name')
        .child('$_newmessagetimestamp')
        .child('comments')
        .child('$timestamp')
        .child('name')
        .set('$_sendername');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var toppadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white70,
      body: new Column(
        children: <Widget>[
          new Container(
            color: Colors.deepPurpleAccent,
            padding: new EdgeInsets.only(top: toppadding),
            child: Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(5.0),
                  color: Colors.deepPurple,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: 55.0,
                        height: 55.0,
                        //margin: EdgeInsets.only(top: 30.0),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(_newurl),
                          ),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(right: 10.0),
                      ),
                      new Text(
                        '$_newname',
                        style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(25.0),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: new Center(
                    child: new Text(
                      '$_newmessage',
                      maxLines: 7,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(
                      left: 7.0, right: 7.0, bottom: 7.0, top: 25.0),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          // Update -> like message and display total count of like in profile
                        },
                        child: new Icon(
                          Icons.thumb_up,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      new GestureDetector(
                        onTap: () {
                          var time = new DateTime.now();
                          print('$time');

                        },
                        child: new Icon(
                          Icons.chat_bubble_outline,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      new GestureDetector(
                        onTap: () {
                          // Update -> Add new functionality
                          print('$size');
                        },
                        child: new Icon(
                          Icons.star_border,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.all(10.0),
                )
              ],
            ),
          ),
          new Expanded(
            child: allData.length == 0
                ? new Center(
                    child: new Container(
                      child: Center(
                        child: new Text('be first one to comment'),
                      ),
                      width: 200,
                      height: 50,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.orangeAccent,
                      ),
                    ),
                  )
                : new ListView.builder(
                    itemCount: allData.length,
                    itemBuilder: (_, index) {
                      return commentUI(
                        allData[index].name,
                        allData[index].image_url,
                        allData[index].comment,
                      );
                    },
                  ),
          ),
          display_textbox == false
              ? new Container(
                  color: Colors.deepPurpleAccent,
                  child: Padding(
                    padding: EdgeInsets.all(05.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new GestureDetector(
                          onTap: () {
                            display_textbox = true;
                            setState(() {});
                          },
                          child: new Container(
                            width: 30,
                            height: 30,
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(50.0),
                              color: Colors.orangeAccent,
                            ),
                            child: new Center(
                              child: new Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.only(left: 5.0),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(bottom: 3.0, top: 3.0),
                      child: new Container(
                        width: (size - 60),
                        height: 35.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(30.0),
                          color: Colors.white,
                        ),
                        child: new Form(
                          key: formKey,
                          child: Padding(
                            padding: new EdgeInsets.only(left: 15.0),
                            child: Center(
                              child: new TextFormField(
                                autofocus: true,
                                decoration: new InputDecoration(
                                  hintText: 'Write a Comment',
                                ),
                                validator: (val) => val.length < 1
                                    ? 'please enter message'
                                    : null,
                                style: new TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                                onSaved: (val) => _message = val,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Padding(padding: new EdgeInsets.all(1.0)),
                    new GestureDetector(
                      onTap: () {
                        submit_comment();
                        display_textbox = false;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => displaymessage()));
                        setState(
                          () {},
                        );
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(50.0),
                          color: Colors.blueAccent,
                        ),
                        child: Center(
                          child: new Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(bottom: 05.0),
                    )
                  ],
                ),
        ],
      ),
    );
  }

  Widget commentUI(String cmnt_name, String cmnt_image, String cmnt) {
    return Column(
      children: <Widget>[
//        new Padding(
//          padding: new EdgeInsets.only(top: 15.0),
//        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(left: 10.0),
            ),
            new Container(
              width: 40,
              height: 40,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage('$cmnt_image'),
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.only(left: 15.0),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  '$cmnt',
                  style: new TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0),
                  textAlign: TextAlign.start,
                ),
                new Text(
                  '$cmnt_name',
                  style: new TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 10),
                )
              ],
            ),
          ],
        ),
//        new Padding(
//          padding: new EdgeInsets.only(top: 5.0),
//        ),
        new Divider(
          color: Colors.black,
        )
      ],
    );
  }

  void updatename(String name) {
    setState(() {
      this._newname = name;
    });
  }

  void updateurl(String url) {
    setState(() {
      this._newurl = url;
    });
  }

  void updatemessage(String message) {
    setState(() {
      this._newmessage = message;
    });
  }

  void updatemessage_timestamp(String message_timestamp) {
    setState(() {
      this._newmessagetimestamp = message_timestamp;
    });
  }

  void update_sendername(String sender_name) {
    setState(() {
      this._sendername = sender_name;
    });
  }

  void update_senderimageurl(String sender_image) {
    setState(() {
      this._senderimageurl = sender_image;
    });
  }
}
