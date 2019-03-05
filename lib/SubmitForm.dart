import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebaseapp/ShowDataPage.dart';
import 'package:time_machine/time_machine.dart';

class SubmitForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(),
      home: new FormPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => new _FormPageState();
}

Future<String> getname() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String name = preferences.getString('name');
  return name;
}

Future<String> getemail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String email = preferences.getString('email');
  return email;
}

Future<String> getdata() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = prefs.getString('image');
  return url;
}

class _FormPageState extends State<FormPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _newname;
  String _newurl;
  String _newemail;

  static var post_time = new DateTime.now();

  static DatabaseReference ref = FirebaseDatabase.instance.reference();

  String _message;

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      submitmessage();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getname().then(updatename);
    getdata().then(updateurl);
    getemail().then(updateemail);
    super.initState();
  }

  void submitmessage() {
    final snackbar = new SnackBar(
      content: new Text("message posted"),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);

    var now = Instant.now();
    var time = now.toString('yyyyMMddHHmm');

//    var time = new DateTime.now().millisecondsSinceEpoch;

    var date_day = new DateTime.now().day;
    var date_month = new DateTime.now().month;
    var date_year = new DateTime.now().year;

    String date = date_day.toString() +
        ':' +
        date_month.toString() +
        ':' +
        date_year.toString();

    if (_newname.isNotEmpty && _message.isNotEmpty) {
      ref.child('node-name').child('$time').child('name').set('$_newname');
      ref.child('node-name').child('$time').child('message').set('$_message');
      ref.child('node-name').child('$time').child('msgtime').set('$date');
      ref.child('node-name').child('$time').child('image').set('$_newurl');
      ref.child('node-name').child('$time').child('email').set('$_newemail');
    }

    // ignore: return_of_invalid_type_from_closure
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ShowDataPage()));
  }

  @override
  Widget build(BuildContext context) {
    final double deviceheight = MediaQuery.of(context).size.height;
    final double keyboardheight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: Text(
          'NEW POST',
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(
                    '$_newname',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              new Container(
                height: deviceheight-keyboardheight-250,
                child: TextFormField(
                  autocorrect: true,
                  scrollPadding: const EdgeInsets.all(20.0),
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                  autofocus: true,
                  decoration: new InputDecoration(
                      hasFloatingPlaceholder: false, errorMaxLines: 3),
                  maxLines: 20,
                  keyboardType: TextInputType.multiline,
                  validator: (val) =>
                      val.length < 1 ? 'please enter message' : null,
                  onSaved: (val) => _message = val,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 50.0),
              ),
              new InkWell(
                onTap: () {
                  _submit();
                  print('this is device height :$deviceheight');
                },
                child: Container(
                  width: 150,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  child: new Center(
                    child: Text(
                      'POST',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
      this._newurl = url;
    });
  }

  void updateemail(String email) {
    setState(() {
      this._newemail = email;
    });
  }
}
