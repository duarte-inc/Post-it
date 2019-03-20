import 'package:flutter/material.dart';
import 'package:firebaseapp/myData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:firebaseapp/userpostdata.dart';

class friendpost extends StatefulWidget {
  @override
  _friendpostState createState() => _friendpostState();
}

Future<String> getuserid() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String userid = preferences.getString('frienduserid');
  return userid;
}

Future<String> getname() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String name = preferences.getString('name');
  return name;
}

Future<String> getdata() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = prefs.getString('image');
  return url;
}

class _friendpostState extends State<friendpost> {
  List<userpostdata> allData = [];
  var verify_email = '';
  var _userid = '';
  String _newname;
  String _newimgurl;

  List normalkey = [];

  var name;
  var imageurl;

  DatabaseReference ref = FirebaseDatabase.instance.reference();

  void initState() {
    getuserid().then(updateuserid);
    getname().then(updatename);
    getdata().then(updateurl);

    setState(() {});

    _comments();

    // get email of the user
  }

  Future<String> _comments() async {
    await new Future.delayed(
      new Duration(milliseconds: 200),
          () {
        print("user id :$_userid");

        ref.child('user').child('$_userid').once().then((DataSnapshot snap) {
          var data = snap.value;
          var key = snap.value.keys;

          name = data['name'];
          imageurl = data['imageurl'];

          print('$name');
          print('$imageurl');

          for(var y in key){
            print('this is y :$y');
            if(y=='name'){
              print('name :$y');
            }
            else if(y=='imageurl'){
              print('imageurl :$y');
            }
            else{
              print('normal :$y');
              normalkey.add(y);
            }

          }
          List list =[];
          for (var x in normalkey){
            list.add(x);
            list.sort();
          }
          var new_normalkey = list.reversed;

          for (var x in new_normalkey) {
            userpostdata userdata =
            new userpostdata(data[x]['message'], data[x]['msgtime']);
            allData.add(userdata);
          }
          setState(() {});
          print("User Data is :$key");
        });
      },
    );

    if(_userid == null){
      _comments();
    }
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
            return UI(allData[index].message, allData[index].msgtime);
          },
        ),
      ),
    );
  }

  Widget UI(String message, String time) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    '$name',
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
            padding: EdgeInsets.only(bottom: 5.0),
          ),
        ],
      ),
    );
  }

  void updatename(String name) {
    setState(() {
      this._newname = name;
    });
  }

  void updateurl(String url) {
    setState(() {
      this._newimgurl = url;
    });
  }

  void updateuserid(String userid) {
    setState(() {
      this._userid = userid;
    });
  }
}
