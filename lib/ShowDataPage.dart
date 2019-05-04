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
import 'package:firebaseapp/about.dart';
import 'package:firebaseapp/Setting.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ShowDataPage extends StatefulWidget {
  @override
  _ShowDataPageState createState() => _ShowDataPageState();
}

// retrieving userid from shredpreference
Future<String> getuserid() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String userid = preferences.getString('userid');
  return userid;
}

// retrieving username from shredpreference
Future<String> getusername() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String username = preferences.getString('name');
//  print('this is user name :$username');
  return username;
}

Future<String> getuserimage() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String userimageurl = preferences.getString('image');
//  print('this is user name :$username');
  return userimageurl;
}

class _ShowDataPageState extends State<ShowDataPage> {
  List<myData> allData = [];
  var sharemessage;

  // list of colors so that every post will have different color
  List<int> color_value = [
    0xFF4B0082,
    0xFFBA55D3,
    0xFFFF66FF,
    0xFFFF8C00,
    0xFFFF7F50
  ];

  var verify_email = '';
  var _userid;

  DatabaseReference ref = FirebaseDatabase.instance.reference();

  static var time = new DateTime.now().millisecondsSinceEpoch;

  var _onTapIndex = 0;

  List<String> timestamplist = [];

  var _newname = '';
  var _userimage;
  List countofcomment = [];
  List countoflikes = [];
  int count = 0, likecount = 0;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();



  @override
  void initState() {
    //retrieving data from firebase database
    //the data is stored using time so that we can sort the key and retrieve it in that format
    //snap.value will give the json format value and snap.value.key will give all the child/key the json contains.

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
        //counting the number of comment the post got.
        //so that the user will get to know the amount of comments that his/her post got

        ref
            .child('node-name')
            .child('$newlist')
            .child('comments')
            .once()
            .then((DataSnapshot datasnap) {
          var key = datasnap.value.keys;
          var commentsnap = datasnap.value;

          for (var x in key) {
            if (x != 'no-comments') {
              count = count + 1;
            } else if (x == 'no-comments') {
//              print('no comments hit :$x');
            }
          }
//          print('adding value count to list');
          countofcomment.add(count);
          count = 0;

          setState(() {});
        });

        //counting the number of likes the post got.
        //so that the user will get to know the amount of likes that his/her post got

        ref
            .child('node-name')
            .child('$newlist')
            .child('likes')
            .once()
            .then((DataSnapshot datasnap) {
          var key = datasnap.value.keys;
          var likesnap = datasnap.value;

          for (var x in key) {
            if (x != 'no-likes') {
              likecount = likecount + 1;
            } else if (x == 'no-comments') {}
          }
          ;
          countoflikes.add(likecount);
          likecount = 0;

          setState(() {});
        });

        timestamplist.add(newlist);

        myData d = new myData(
            data[newlist]['name'],
            data[newlist]['message'],
            data[newlist]['msgtime'],
            data[newlist]['image'],
            data[newlist]['userid']);
        allData.add(d);
      }
      setState(() {});
    });
    getuserimage().then(updateurl);
    getusername().then(updatename);
    getuserid().then(updateuserid);
  }

  _likesnackbar() {
    final snackbar = new SnackBar(
      content: new Text('Liked'),
      duration: new Duration(milliseconds: 2000),
      backgroundColor: Colors.green,
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          centerTitle: true,
          title: Text(
            'Post it',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(
                  _newname,
                  style: new TextStyle(fontSize: 18.0),
                ),
                accountEmail: new Text(_newname),
                currentAccountPicture: new Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                        image: NetworkImage(_userimage),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 7.0, color: Colors.black)
                    ],
                  ),
                ),
              ),
              new ListTile(
                leading: new Icon(Icons.person),
                title: new Text(
                  'Profile',
                  style: new TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => profile()));
                },
              ),
              new Divider(
                height: 0.0,
                color: Colors.black,
              ),
              new ListTile(
                leading: new Icon(Icons.accessibility),
                title: new Text(
                  'About',
                  style: new TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => about()));
                },
              ),
              new Divider(
                height: 0.0,
                color: Colors.black,
              ),
              new ListTile(
                leading: new Icon(Icons.settings),
                title: new Text(
                  'Setting',
                  style: new TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => setting()));
                },
              ),
              new Divider(
                height: 0.0,
                color: Colors.black,
              ),
            ],
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
                Save_data(null, _newname, sharemessage, null, _userid, null);
                setState(() {
                  _onTapIndex = 0;
                });
              } else if (index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => profile()));
                Save_data(null, _newname, sharemessage, null, _userid, null);
                setState(() {
                  _onTapIndex = 0;
                });
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
            child: countofcomment.length == 0
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
                        timestamplist[index],
                        countofcomment[index],
                        allData[index].userid,
                        countoflikes[index],
                      );
                    },
                  ),
          ),
          onRefresh: _handleRefresh,
        ),
      ),
    );
  }

  Widget UI(String name, String message, String datetime, String image,
      String timestamp, int cmntcount, String userid, int likecount) {
    return new InkWell(
      onTap: () {
        sharemessage = message;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => displaymessage()));
        Save_data(image, name, sharemessage, timestamp, userid, null);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        child: Column(
          children: <Widget>[
            Slidable(
              delegate: new SlidableDrawerDelegate(),
              actionExtentRatio: 0.25,
              child: new Card(
                child: new Container(
                  color: Color(color_value[Random().nextInt(5)]),
                  padding: new EdgeInsets.all(20.0),
                  child: new Column(
                    children: <Widget>[
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
                        padding: EdgeInsets.all(7.0),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              new GestureDetector(
                                onTap: () {
                                  // Update -> like message and display total count of like in profile
                                  ref.child('node-name').child('$timestamp').child('likes').child('$_userid').child('name').set('$_newname');
                                  _likesnackbar();
                                  },
                                child: new Icon(
                                  Icons.thumb_up,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              new Text(
                                '${likecount}',
                                style: new TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          new GestureDetector(
                            onTap: () {
                              // Update -> comment on message

                            },
                            child: Row(
                              children: <Widget>[
                                new Icon(
                                  Icons.chat_bubble_outline,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                countofcomment.length == 0
                                    ? new Text('0')
                                    : Text(
                                        '$cmntcount',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ],
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
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:4.0, bottom:4.0),
                  child: new IconSlideAction(
                    caption: 'Report',
                    color: Colors.redAccent,
                    icon: Icons.report,
                    onTap: (){
                      ref.child('user').child('$userid').child('Report').set('true');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: new IconSlideAction(
                    icon: Icons.more,
                    caption: 'More',
                    color: Colors.deepOrangeAccent,
                  ),
                )
              ],
            ),
            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                new InkWell(
                  onTap: () {
                    // comparing the userid to check whether the userid is of the corrent user or the other user
                    // if the userid is of the current user show the user's profile
                    // if the userid is not of the current user show the profile of that user

                    if (_userid == userid) {
                      // have to reset the sharedpref so that the other users data should not get shown accidentally
                      Save_data(null, null, null, null, null, null);
                      Save_data(
                          image, name, sharemessage, timestamp, userid, null);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => profile()));
                      Save_data(
                          image, name, sharemessage, timestamp, userid, null);
//                      print('user id :$userid');
                    } else {
                      Save_data(null, null, null, null, null, null);
                      Save_data(image, name, sharemessage, timestamp, _userid,
                          userid);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => friendprofile()));
                      Save_data(image, name, sharemessage, timestamp, _userid,
                          userid);
//                      print('friend id :$userid');
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      '$name',
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
    await new Future.delayed(new Duration(seconds: 1));
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ShowDataPage()));
    });
    return null;
  }

  void Save_data(String url, String name, String message, String timestamp,
      String userid, String frienduserid) {
    String newurl = url;
    String newname = name;
    String newmessage = message;
    String message_timestamp = timestamp;
    String newuserid = userid;
    String newfrienduserid = frienduserid;
    Save_SharedMessageData(newurl, newname, newmessage, message_timestamp,
        newuserid, newfrienduserid);
  }

  void updatename(String name) {
    setState(() {
      this._newname = name;
    });
  }

  void updateurl(String url) {
    setState(() {
      this._userimage = url;
    });
  }

  void updateuserid(String userid) {
    setState(() {
      this._userid = userid;
    });
  }
}

// building shredpref to store and share data with display_message.dart

Future<bool> Save_SharedMessageData(
    String imageurl,
    String name,
    String message,
    String message_timestamp,
    String userid,
    String frienduserid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('message_image', imageurl);
  prefs.setString('message_name', name);
  prefs.setString('message', message);
  prefs.setString('message_timestamp', message_timestamp);
  prefs.setString('userid', userid);
  prefs.setString('frienduserid', frienduserid);
  return prefs.commit();
}
