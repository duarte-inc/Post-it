import 'package:flutter/material.dart';
import 'package:firebaseapp/ShowDataPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(
      new MaterialApp(
        home: homepage(),
        debugShowCheckedModeBanner: false,
        title: 'Post-it',
        theme: new ThemeData(primarySwatch: Colors.deepPurple),
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
  print('this is token :$token');
  return token;
}

class _homepageState extends State<homepage> {
  var _token;

  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  DatabaseReference ref = FirebaseDatabase.instance.reference();

  //Remember to remove both key
  //you have to fill the form to get api and secret key
  static final TwitterLogin twitterLogin = new TwitterLogin(
    consumerKey: 'your key',
    consumerSecret: 'your secret key',
  );



  //Google login
  //login proved us with username, imageurl, token and user id
  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    FirebaseUser user = await _fAuth.signInWithGoogle(
        idToken: gSA.idToken, accessToken: gSA.accessToken);
    var displayname = user.displayName;
    var photourl = user.photoUrl;
    var useremail = user.email;
    var userid = googleSignInAccount.id;
    var token = gSA.accessToken;
    savealldata(photourl, displayname, useremail, userid, token);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowDataPage()));

    print('is this gsa :$gSA');
    print('is this token :${gSA.idToken}');
    print('is this accesstoken :${gSA.accessToken}');
    print('is this proverid :${user.providerId}');
    print('googlesigninaccount id :${googleSignInAccount.id}');

    ref.child('user').child(userid).child('imageurl').set(photourl);
    ref.child('user').child(userid).child('name').set(displayname);

    return null;
  }

  // Twitter Login
  // Remember to remove secret key and api key before uploading to github
  // Twitter doesnt provide the user image url so i am using a default image which will be same for every user.

  void _login() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        var name = result.session.username;
        var image =
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRi-I5E9Vn6dFsuJnrJfJVcpNp6KNQ74ZSjKoGn5t9-pGLddxDG';
        var userid = result.session.userId;
        var accesstoken = result.session.token;
        print('twitter name :${result.session.username}');
        print('twitter name :${result.session.userId}');
        print('${result.session.token}');
        savealldata(image, name, null, userid, accesstoken);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShowDataPage()));
        break;
      case TwitterLoginStatus.cancelledByUser:
        break;
      case TwitterLoginStatus.error:
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _gettoken();
    getaccesstoken().then(updatetoken);
    super.initState();
  }

  //creating session which will store the token of the user and check whether the token is present or not
  // If token is present it will redirect to the homepage otherwise landing / login page
  Future<String> _gettoken() async {
    await new Future.delayed(
      new Duration(milliseconds: 800), () {
        print('this is received token :$_token');

        if (_token != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ShowDataPage()));
        } else {
          print('token not found login again');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return
    WillPopScope(
      onWillPop: () async=> false,
      child: Scaffold(
        body: Center(
          child: Container(
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
                    child: new InkWell(
                      onTap: () {
                        _signIn();
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.redAccent,
                        shadowColor: Colors.redAccent.withOpacity(0.8),
                        elevation: 7.0,
                        child: Center(
                          child: new Text(
                            'Login in with Google',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
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
                    child: new InkWell(
                      onTap: () {
                        _login();
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.lightBlue,
                        shadowColor: Colors.lightBlue.withOpacity(0.8),
                        elevation: 7.0,
                        child: Center(
                          child: new Text(
                            'Login in with Twitter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(8.0),
                  ),
                ],
              ),
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


  // Storing data to send it into sharedpreference
  void savealldata(
      String url, String name, String email, String uid, String access_token) {
    String newurl = url;
    String newname = name;
    String newemail = email;
    String userid = uid;
    String token = access_token;
    savedata(newurl, newname, newemail, userid, token);
  }
}
  // Shared preference is used to store data so that data not have to be taken from database again and again
  // Storing data like : imageurl, name, email, userid, and token
Future<bool> savedata(String imageurl, String name, String email, String userid, String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("image", imageurl);
  prefs.setString('name', name);
  prefs.setString('email', email);
  prefs.setString('userid', userid);
  prefs.setString('token', token);
  return prefs.commit();
}
