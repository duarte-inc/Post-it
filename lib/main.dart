import 'package:flutter/material.dart';
import 'package:firebaseapp/ShowDataPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_machine/time_machine.dart';

void main() => runApp(
      new MaterialApp(
        home: homepage(),
        debugShowCheckedModeBanner: false,
        title: 'Post-it',
        color: Colors.deepPurpleAccent,
      ),
    );

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

Future<String> getaccesstoken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token = preferences.getString('token');
  return token;
}

class _homepageState extends State<homepage> {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  var _token;

  var _display = '';

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    FirebaseUser user = await _fAuth.signInWithGoogle(
        idToken: gSA.idToken, accessToken: gSA.accessToken);
    var displayname = user.displayName;
    var photourl = user.photoUrl;
    var useremail = user.email;
    var userid = user.uid;

    _display = displayname;
    savealldata(photourl, displayname, useremail, userid, gSA.accessToken);
    Navigator.push(
        context, MaterialPageRoute(builder: (contet) => ShowDataPage()));

    print('is this token :$gSA');
    print('is this token :${gSA.idToken}');
    print('is this token :${gSA.accessToken}');

//    print('User data :$user');
//
//    print('bitch lasagna :$userid');

    return null;
  }

  @override
  void initState() {
    // TODO: implement initState

    getaccesstoken().then(updatetoken);

    _gettoken();

    super.initState();
  }


  Future<String> _gettoken() async {
    await new Future.delayed(new Duration(milliseconds: 1000), () {
      print('this is received token :$_token');

      if(_token != null){
//        Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowDataPage()));
      }
      else{
        print('token not found login again');
      }

    });
  }

  void signout() {
    googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: Center(
        child: new Container(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: new Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 60),
                ),
                new Image(
                  image: AssetImage('asset/mainlogo.png'),
                ),
                new Container(
                  width: 250,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.red,
                  ),
                  child: new Material(
                    color: Colors.transparent,
                    child: new InkWell(
                      onTap: () {
                        _signIn();
                      },
                      child: new Container(
                        child: Center(
                          child: new Text(
                            'Login in with Google',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                new Container(
                  width: 250,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.orangeAccent,
                  ),
                  child: new Material(
                    color: Colors.transparent,
                    child: new InkWell(
                      onTap: () {
                        signout();
                      },
                      child: new Container(
                        child: Center(
                          child: new Text(
                            'Sign out',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updatetoken(String token) {
    setState(() {
      this._token = token;
    });
  }

  void savealldata(String url, String name, String email, String uid, String access_token) {
    String newurl = url;
    String newname = name;
    String newemail = email;
    String userid = uid;
    String token = access_token;
    savedata(newurl, newname, newemail, userid, token);
  }
}


Future<bool> savedata(String imageurl, String name, String email, String userid, String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("image", imageurl);
  prefs.setString('name', name);
  prefs.setString('email', email);
  prefs.setString('userid', userid);
  prefs.setString('token', token);
  return prefs.commit();
}
