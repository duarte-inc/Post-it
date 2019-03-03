import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class addimage extends StatefulWidget {
  @override
  _addimageState createState() => _addimageState();
}

class _addimageState extends State<addimage> {
  static var time = new DateTime.now().millisecondsSinceEpoch;

  StorageReference ref =
      FirebaseStorage.instance.ref().child('image').child('$time');
  StorageUploadTask task;

  File sampleImage;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text(
          'ADD IMAGE',
          style: new TextStyle(fontWeight: FontWeight.w300),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        getImage();
      }),
      body: new Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(
              top: 10,
            ),
          ),
          new Container(
            width: 400,
            height: 400,
            child: sampleImage == null
                ? new Center(child: Text('Please Select an Image to Upload'))
                : enableUpload(),
          ),
          new Container(
            child: sampleImage == null
                ? null
                : RaisedButton(
                    child: new Text('UPLOAD'),
                    onPressed: () {
                      task = ref.putFile(sampleImage);
                      if (task.isInProgress) {
                        print('uploaded successfully');
                      }
                    },
                  ),
          )
        ],
      ),
    );
  }

  Widget enableUpload() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Image.file(
            sampleImage,
            width: 400,
            height: 400,
          ),
        ],
      ),
    );
  }
}
