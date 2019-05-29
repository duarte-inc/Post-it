import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebaseapp/user/profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebaseapp/friend/friendpost.dart';
import 'package:flare_flutter/flare_actor.dart';

class friendprofile extends StatefulWidget {
  @override
  _friendprofileState createState() => _friendprofileState();
}

Future<String> getuserid() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String userid = preferences.getString('frienduserid');
  print('this is something :$userid');
  return userid;
}

class _friendprofileState extends State<friendprofile> {
  var _friendname;
  var _friendimageurl;
  var _userid;
  var _count = 0;

  DatabaseReference ref = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    getuserid().then(update_userid);
    setState(() {});
    userdata();
    countofpost();

    super.initState();
  }

  Future userdata() async {
    await new Future.delayed(Duration(milliseconds: 0), () {
      ref.child('user').child('$_userid').once().then((DataSnapshot snap) {
        var data = snap.value;

        _friendname = data['name'];
        _friendimageurl = data['imageurl'];

//        print('this is friends key :$_friendname');
//        print('this is friends data :$_friendimageurl');

        setState(() {});
      });
    });
  }

  Future countofpost() async {
    await Future.delayed(Duration(milliseconds: 100), () {
      ref.child('user').child('$_userid').once().then((DataSnapshot snap) {
        var key = snap.value.keys;
        var data = snap.value;

        for (var x in key) {
          if (x != 'name' && x != 'imageurl') {
            _count = _count + 1;
          } else {
            print('random key hit :$x');
          }
        }

        setState(() {});

        print('count :$_count');

        print('data :$data');
        print('keys are :$key');
      });
    });
    if (_userid == null) {
      countofpost();
    }
  }

  void changepage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => profile()));
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: _friendname == null
          ? new Center(
              child: FlareActor(
                'asset/linear.flr',
                animation: 'linear',
                fit: BoxFit.contain,
              ),
            )
          : new Stack(
              children: <Widget>[
                ClipPath(
                  child: Container(color: Colors.black.withOpacity(0.8)),
                  clipper: getClipper(),
                ),
                Positioned(
                  width: 350.0,
                  top: MediaQuery.of(context).size.height / 5,
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              image: DecorationImage(
                                  image: NetworkImage(_friendimageurl),
                                  fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(75.0)),
                              boxShadow: [
                                BoxShadow(blurRadius: 7.0, color: Colors.black)
                              ])),
                      SizedBox(height: 30.0),
                      Text(
                        '$_friendname',
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => friendpost()));
                        },
                        child: Container(
                            height: 40.0,
                            width: 105.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.greenAccent,
                              color: Colors.green,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'POSTS',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(height: 25.0),
//                      Container(
//                        height: 40.0,
//                        width: 105.0,
//                        child: Material(
//                          borderRadius: BorderRadius.circular(20.0),
//                          shadowColor: Colors.redAccent,
//                          color: Colors.red,
//                          elevation: 7.0,
//                          child: GestureDetector(
//                            onTap: () {},
//                            child: Center(
//                              child: Text(
//                                'Log out',
//                                style: TextStyle(
//                                    color: Colors.white,
//                                    fontFamily: 'Montserrat'),
//                              ),
//                            ),
//                          ),
//                        ),
//                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }

  void update_userid(String userid) {
    setState(() {
      this._userid = userid;
    });
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height/2);
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
