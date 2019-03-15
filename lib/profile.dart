import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebaseapp/addimage.dart';
import 'package:firebaseapp/userpost.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    getdata().then(updateurl);
    getname().then(updatename);
    getMessageCount().then(updateMessage_count);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.transparent,
//        elevation: 0.0,
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back),
//          color: Colors.black,
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//        ),
//      ),

      body: Container(
        color: Colors.deepPurpleAccent,
        child: new Column(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(top: 60),
            ),
            new Center(
              child: Container(
                width: 125.0,
                height: 125.0,
                //margin: EdgeInsets.only(top: 30.0),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(_newurl),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25.0),
            new Text(
              (_newname),
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
                        '$_newcount',
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

                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>userpost()));

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
                            '$_newcount',
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
                new GestureDetector(
                  onTap: () {
                    print('Tapped');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => addimage()));
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
                      child: new Text(
                        'ADD PHOTOS',
                        style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
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
