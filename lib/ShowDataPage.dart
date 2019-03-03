import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebaseapp/myData.dart';
import 'dart:async';
import 'package:firebaseapp/SubmitForm.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:firebaseapp/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' show Random;
import 'package:firebaseapp/display_message.dart';
import 'package:firebaseapp/friendprofile.dart';

class ShowDataPage extends StatefulWidget {
  @override
  _ShowDataPageState createState() => _ShowDataPageState();
}

Future<String> getemail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String email = preferences.getString('email');
  return email;
}

Future<String> getusername() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String username = preferences.getString('name');
  print('this is user name :$username');
  return username;
}


class _ShowDataPageState extends State<ShowDataPage> {
  List<myData> allData = [];
  var sharemessage;

  List<int> color_value = [
    0xFF4B0082,
    0xFFBA55D3,
    0xFFFF66FF,
    0xFFFF8C00,
    0xFFFF7F50
  ];

  var _newemail = '';
  var _count_number_of_message = 0;
  var verify_email = '';

  static var time = new DateTime.now().millisecondsSinceEpoch;

  var _onTapIndex = 0;

  List<String> timestamplist = [];

  var _newname='';

  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();

    ref.child('node-name').once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;

      List list = [];

      for (var key in keys) {
        list.add(key);
        list.sort();
      }

      var reversed = list.reversed;

      for (var newlist in reversed) {
        //list.sort();
        //list.reversed;

        timestamplist.add(newlist);

        myData d = new myData(
          data[newlist]['name'],
          data[newlist]['message'],
          data[newlist]['msgtime'],
          data[newlist]['image'],
          verify_email = data[newlist]['email'],
        );

        if (verify_email == _newemail) {
          _count_number_of_message += 1;
        }
        allData.add(d);
      }

      if (_count_number_of_message != 0) {
        savemessagecount(_count_number_of_message);
      }

      setState(() {});
    });

    getemail().then(updateemail);
    getusername().then(updatename);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          centerTitle: true,
          title: Text(
            'Post it',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _onTapIndex,
          onTap: (int index) {
            setState(() {
              _onTapIndex = index;
              if (index == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SubmitForm()));
              } else if (index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => profile()));
              }
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.add),
              title: new Text('post it'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ],
        ),
        body: new RefreshIndicator(
          child: new Container(
            padding: EdgeInsets.only(top: 03.0),
//            margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            child: allData.length == 0
                ? new Center(
                    child: FlareActor(
                      'asset/linear.flr',
                      animation: 'linear',
                      fit: BoxFit.contain,
                    ),
                  )
                : new ListView.builder(
                    itemCount: allData.length,
                    itemBuilder: (_, index) {
                      return UI(
                          allData[index].name,
                          allData[index].message,
                          allData[index].msgtime,
                          allData[index].image,
                          timestamplist[index]);
                    },
                  ),
          ),
          onRefresh: _handleRefresh,
        ),
      ),
    );
  }

  Widget UI(String name, String message, String datetime, String image, String timestamp) {
    return new InkWell(
      onTap: () {
        sharemessage = message;
        print('message is :$sharemessage');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => displaymessage()));
        print('this is message timestamp :$time');
        Save_data(image, name, sharemessage, timestamp);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        child: Column(
          children: <Widget>[
            new Card(
              child: new Container(
                color: Color(color_value[Random().nextInt(5)]),
                padding: new EdgeInsets.all(20.0),
                child: new Column(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.all(2.0),
                    ),
                    new Text(
                      '$message',
                      maxLines: 5,
//                    style: Theme.of(context).textTheme.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    new Padding(
                      padding: EdgeInsets.all(2.0),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new GestureDetector(
                          onTap: () {
                            // Update -> like message and display total count of like in profile
                          },
                          child: new Icon(
                            Icons.thumb_up,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        new GestureDetector(
                          onTap: () {
                            // Update -> comment on message
                          },
                          child: new Icon(
                            Icons.chat_bubble_outline,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        new GestureDetector(
                          onTap: () {
                            // Update -> Add new functionality
                          },
                          child: new Icon(
                            Icons.star_border,
                            size: 20,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                new InkWell(
                  onTap: (){
                   if(_newname==name){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>profile()));
                   }
                   else{
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>friendprofile()));
                     Save_data(image, name, sharemessage, timestamp);
                   }
                  },
                  child: new Container(
                    width: 40.0,
                    height: 40.0,
                    //margin: EdgeInsets.only(top: 30.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage('$image'),
                      ),
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(right: 10.0),
                ),
                new Column(
                  children: <Widget>[
                    new Text(
                      '- $name',
//                    style: TextStyle(color: Colors.white),
                    ),
                    new Text(
                      '$datetime',
                    ),
                  ],
                ),
              ],
            ),
            new Padding(
              padding: EdgeInsets.only(bottom: 15.0),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ShowDataPage()));
    });
    return null;
  }

  void updateemail(String email) {
    setState(() {
      this._newemail = email;
    });
  }

  void savemessagecount(int count) {
    int newcount = count;
    savedatamessagecount(newcount);
  }

  void Save_data(String url, String name, String message, String timestamp) {
    String newurl = url;
    String newname = name;
    String newmessage = message;
    String message_timestamp = timestamp;
    Save_SharedMessageData(newurl, newname, newmessage, message_timestamp);
  }
  void updatename(String name) {
    setState(() {
      this._newname = name;
    });
  }
}

Future<bool> savedatamessagecount(int message_count) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('1', message_count);
  return prefs.commit();
}

Future<bool> Save_SharedMessageData(
    String imageurl, String name, String message, String message_timestamp) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('message_image', imageurl);
  prefs.setString('message_name', name);
  prefs.setString('message', message);
  prefs.setString('message_timestamp', message_timestamp);
  return prefs.commit();
}
