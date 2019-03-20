import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebaseapp/userpost.dart';
import 'package:firebaseapp/main.dart';
import 'package:firebaseapp/ShowDataPage.dart';

class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

Future<String> getdata() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = prefs.getString('image');
  return url;
}

Future<int> getMessageCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int Message_count = prefs.getInt('1');
  return Message_count;
}

Future<String> getname() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String name = preferences.getString('name');
  return name;
}

Future<String> getuserid() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String userid = preferences.getString('userid');
  return userid;
}

class _profileState extends State<profile> {
  String _newurl = '';
  String _newname = '';
  int _newcount;
  String _userid;

  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    // TODO: implement initState


    getdata().then(updateurl);
    getname().then(updatename);
    getMessageCount().then(updateMessage_count);
    super.initState();
  }

  void signout() {
    googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var topheight = MediaQuery.of(context).padding.top;
    var device_width = MediaQuery.of(context).size.width;
    return Scaffold(
//      backgroundColor: Colors.redAccent,
      body: new Stack(
        children: <Widget>[
          ClipPath(
            child: Container(color: Colors.redAccent.withOpacity(0.9)),
            clipper: getClipper(),
          ),
          Positioned(
            width: device_width,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[
                Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                            image: NetworkImage(_newurl), fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ])),
                SizedBox(height: 30.0),
                Text(
                  '$_newname',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 15.0),
                Text(
                  'STATUS',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 25.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => userpost()));
                  },
                  child: Container(
                    height: 50.0,
                    width: 150.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(25.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.green,
                      elevation: 7.0,
                      child: Center(
                        child: Text(
                          'POSTS',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                GestureDetector(
                  onTap: (){
                    signout();
                    savedata(null, null, null, null, null);
                    Save_SharedMessageData(null, null, null, null, null, null);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage()));
                  },
                  child: Container(
                      height: 50.0,
                      width: 150.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        shadowColor: Colors.redAccent,
                        color: Colors.red,
                        elevation: 7.0,
                        child: Center(
                          child: Text(
                            'Log out',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void updateurl(String url) {
    setState(() {
      this._newurl = url;
    });
  }

  void updatename(String name) {
    setState(() {
      this._newname = name;
    });
  }

  void updateMessage_count(int count) {
    setState(() {
      this._newcount = count;
      print('Count of Message posted : $_newcount');
    });
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
