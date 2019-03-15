import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebaseapp/profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebaseapp/userpost.dart';
import 'package:firebaseapp/friendpost.dart';

class friendprofile extends StatefulWidget {
  @override
  _friendprofileState createState() => _friendprofileState();
}

Future<String> getname() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String name = preferences.getString('message_name');
  print('this is something :$name');
  return name;
}

Future<String> getuserid() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String userid = preferences.getString('frienduserid');
  print('this is something :$userid');
  return userid;
}

Future<String> getmessage_imageurl() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = prefs.getString('message_image');
  print('$url');
  return url;
}

class _friendprofileState extends State<friendprofile> {
  var _sendername;
  var _senderimageurl;
  var _userid;
  
  DatabaseReference ref = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    getname().then(update_sendername);
    getmessage_imageurl().then(update_senderimageurl);
    getuserid().then(update_userid);

    setState(() {});

    userdata();

    
    super.initState();
  }

  Future userdata() async{

    await new Future.delayed(Duration(milliseconds: 100),(){

      ref.child('user').child('$_userid').once().then((DataSnapshot snap){

        var data = snap.value;
        var key = snap.key;

        print('this is friends key :$key');
        print('this is friends data :$data');

      });

    });

  }


  void changepage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => profile()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
              color: Colors.deepPurpleAccent,
              child: new Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top: 60)),
                  new Center(
                    child: Container(
                      width: 125.0,
                      height: 125.0,
                      //margin: EdgeInsets.only(top: 30.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(_senderimageurl),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  new Text(
                    (_sendername),
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '24K',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'FOLLOWERS',
                              style: TextStyle(
                                  fontFamily: 'Montserrat', color: Colors.grey),
                            )
                          ],
                        ),
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Private',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'POST',
                              style: TextStyle(
                                  fontFamily: 'Montserrat', color: Colors.grey),
                            )
                          ],
                        ),
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '21',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'FOLLOWING',
                              style: TextStyle(
                                  fontFamily: 'Montserrat', color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(left: 20.0),
                      ),
                      new GestureDetector(
                        onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>friendpost()));
                        userdata();
                        },
                        child: new Container(
                          width: 135,
                          height: 135,
                          decoration: new BoxDecoration(
//                    borderRadius: BorderRadius.circular(10.0),
                            color: Colors.transparent,
                            border: Border.all(style: BorderStyle.solid),
                          ),
                          child: Center(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  'Private',
                                  style: new TextStyle(
                                    fontSize: 35,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                                new Text(
                                  'POSTS',
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(right: 20.0),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
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

  void update_userid(String userid) {
    setState(() {
      this._userid = userid;
    });
  }

}
