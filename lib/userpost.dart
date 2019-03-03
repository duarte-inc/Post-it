import 'package:flutter/material.dart';
import 'package:firebaseapp/myData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flare_flutter/flare_actor.dart';

class userpost extends StatefulWidget {
  @override
  _userpostState createState() => _userpostState();
}

Future<String> getemail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String email = preferences.getString('email');
  return email;
}

class _userpostState extends State<userpost> {
  List<myData> allData = [];
  var verify_email = '';
  var _newemail = '';

  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();

    ref.child('node-name').once().then(
      (DataSnapshot snap) {
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
          myData d = new myData(
            data[newlist]['name'],
            data[newlist]['message'],
            data[newlist]['msgtime'],
            data[newlist]['image'],
            verify_email = data[newlist]['email'],
          );
          if (verify_email == _newemail) {
            allData.add(d);
          }
        }
        print('passed email :$_newemail');
        setState(() {});
      },
    );
    // get email of the user
    getemail().then(updateemail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        title: new Text(
          'YOU POSTED',
          style: new TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
      body: new Container(
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
                  );
                },
              ),
      ),
    );
  }

  Widget UI(String name, String message, String time, String imageurl) {
    return Container(
      width: 300,
      margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      child: Column(
        children: <Widget>[
          new Card(
            child: new Container(
              color: Colors.deepOrangeAccent,
              padding: new EdgeInsets.all(20.0),
              child: new Column(
                mainAxisSize: MainAxisSize.max,
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
              new Container(
                width: 40.0,
                height: 40.0,
                //margin: EdgeInsets.only(top: 30.0),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage('$imageurl'),
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
                    '$time',
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
    );
  }

  void updateemail(String email) {
    setState(() {
      this._newemail = email;
    });
  }
}
