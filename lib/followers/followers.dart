import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebaseapp/data/myFollower.dart';

class followers extends StatefulWidget {
  @override
  _followersState createState() => _followersState();
}

class _followersState extends State<followers> {
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  List<myFollower> allData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref
        .child('user')
        .child('102157647429121257673')
        .child('follower')
        .once()
        .then((DataSnapshot snap) {
      var key = snap.value.keys;
      var data = snap.value;

      print('this is key :$key');
      print('this is data :$data');

      if (data != null) {
        myFollower myfollower = new myFollower(
            data['$key'], data['123']['name'], data['123']['image_url']);
        allData.add(myfollower);
      } else {
        print('lol loser no followers');
      }
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Followers'),
      ),
      body: new Container(
        child: allData.length != 0
            ? new ListView.builder(
                itemCount: allData.length,
                itemBuilder: (_, index) {
                  return UIFollower(
                      allData[index].name, allData[index].image_url);
                })
            : new Text('no data'),
      ),
    );
  }

  Widget UIFollower(String name, String image_url) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Text('$name'),
          new Image(
            image: NetworkImage('$image_url'),
          ),
        ],
      ),
    );
  }
}
