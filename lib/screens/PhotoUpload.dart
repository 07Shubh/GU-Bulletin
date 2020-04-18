import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class UploadPhotoImage extends StatefulWidget {
  @override
  _UploadPhotoImageState createState() => _UploadPhotoImageState();
}

class _UploadPhotoImageState extends State<UploadPhotoImage> {
  File sampleImage;
  String _myValue;
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

    }
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
        tooltip: 'Add Image from Gallery',
        child: Icon(Icons.add_a_photo),
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
                return value.isEmpty?'Blogg description is required':null;
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
