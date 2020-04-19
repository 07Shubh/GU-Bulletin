import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gu_bulletin/screens/home.dart';

class UploadPhotoImage extends StatefulWidget {
  @override
  _UploadPhotoImageState createState() => _UploadPhotoImageState();
}

class _UploadPhotoImageState extends State<UploadPhotoImage> {
  File sampleImage;
  String _myValue, url;
  final formKey = GlobalKey<FormState>();

  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave() {
      final form = formKey.currentState;
      if(form.validate()){
        form.save();
        return true;
      }
      else{
        return false;
      }
  }

  void uploadStatusImage() async{
    if(validateAndSave()){
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = DateTime.now();
      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString()+".jpg").putFile(sampleImage);
      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = ImageUrl.toString();
      print("Image URL = " + url);

      goToHomePage();
      saveToDatabase(url);
    }
  }

  void saveToDatabase(url){
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');
    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      'image': url,
      'description': _myValue,
      'date': date,
      'time': time,
    };
    
    ref.child("Posts").push().set(data);
  }

  void goToHomePage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return Home();
        }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null? Text("Select an Image"):enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        backgroundColor: Colors.blue,
        tooltip: 'Add Image from Gallery',
        child: Icon(Icons.collections),
        splashColor: Colors.blue,
      ),
    );
  }

  Widget enableUpload(){
    return Container(
      child: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Image.file(sampleImage, height: 330.0, width: 660.0),
            SizedBox(height: 15.0,),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value){
                return value.isEmpty?'Description is required':null;
              },
              onSaved: (value){
                return _myValue = value;
              },
            ),
            SizedBox(height: 15.0,),
            RaisedButton(
                onPressed: uploadStatusImage,
                elevation: 10.0,
                child: Text('Post'),
                textColor: Colors.white,
                color: Colors.blue,
                splashColor: Colors.indigo,

            ),

          ],
        ),
      ),
    );
  }

}
