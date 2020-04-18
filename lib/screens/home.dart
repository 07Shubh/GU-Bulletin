import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:gu_bulletin/screens/PhotoUpload.dart';
import 'package:intl/intl.dart';
import '../mapping.dart';
import 'package:flutter/material.dart';
import 'package:gu_bulletin/authentication.dart';
import 'package:gu_bulletin/screens/PhotoUpload.dart';
import 'package:gu_bulletin/Posts.dart';

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
  List<Posts> postsList = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child(
        "Posts");
    postsRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();
      for (var individualKey in KEYS) {
        Posts posts = new Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
        );
        postsList.add(posts);
      }

      setState(() {
        print('Length : ${postsList.length}');
      });
    }
    );
  }


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
                MaterialPageRoute(builder: (context) {
                  return UploadPhotoImage();
                })
            );
          },
        ),
      ),
      body: Container(
        child: postsList.length ==0? Text('No news available at the moment'): ListView.builder(
            itemCount: postsList.length,
            itemBuilder: (_,index){
              return PostsUI(postsList[index].image, postsList[index].date, postsList[index].time, postsList[index].description);
        })
      ),
    );
  }
    Widget PostsUINew(String image, String description, String date, String time) {
      return Card(
        elevation: 10.0,
        margin: EdgeInsets.all(15.0),
        child: Container(
          padding: EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    date,
                    style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    time,
                    style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Image.network(image, fit:BoxFit.cover),
              SizedBox(height: 10.0,),
              Text(
                description,
                style: Theme.of(context).textTheme.subhead,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    Widget PostsUI(String image, String date, String time, String description){
      return Container(
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
                      SizedBox(width: 10.0,),
                      Text('Test', style: TextStyle(fontWeight: FontWeight.bold,),),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Image.network(image, fit: BoxFit.cover,),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.arrow_upward),
                  //SizedBox(width: 1.0,),
                  Icon(Icons.arrow_downward),
                  //SizedBox(width: 1.0,),
                  Icon(Icons.reply),
                  //SizedBox(width: 1.0,),
                  Icon(Icons.share),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Text(date, style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,),
                  SizedBox(width: 16.0,),
                  Text(time, style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(description, style: Theme.of(context).textTheme.subtitle,),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add a comment...",
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
}