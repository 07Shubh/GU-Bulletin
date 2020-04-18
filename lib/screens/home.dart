import 'package:flutter/cupertino.dart';
import 'package:gu_bulletin/screens/PhotoUpload.dart';
import '../mapping.dart';
import 'package:flutter/material.dart';
import 'package:gu_bulletin/authentication.dart';
import 'package:gu_bulletin/screens/PhotoUpload.dart';

class Home extends StatefulWidget {
  Home({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Dashboard'),
        backgroundColor: Colors.blue,
        elevation: 2.0,
      ),
      drawer: Drawer(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0),
              ),
              MaterialButton(
                child: ListTile(
                  title: Text('SignOut'),
                  //onTap: _logoutUser,
                ),
                onPressed: _logoutUser,
              )
            ],
          ),
        ),
      ),
      floatingActionButton:
      Container(
        child: FloatingActionButton(
          child: Icon(Icons.add,),
          tooltip: 'Upload a post',
          autofocus: true,
          clipBehavior: Clip.antiAlias,
          elevation: 5.0,
          splashColor: Colors.indigo,
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context){
               return UploadPhotoImage();
              })
            );
          },
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text('Admin', style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Icon(Icons.add_a_photo,),

            ),
          ],
        ),
      ),
    );
  }
}
