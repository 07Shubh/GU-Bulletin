import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gu_bulletin/screens/PhotoUpload.dart';
import 'package:intl/intl.dart';
import '../mapping.dart';
import 'package:flutter/material.dart';
import 'package:gu_bulletin/authentication.dart';
import 'package:gu_bulletin/screens/PhotoUpload.dart';
import 'package:gu_bulletin/Posts.dart';
import 'package:gu_bulletin/dialogbox.dart';

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
  DialogBox dialogBox = DialogBox();
  String _locationMessage;

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

  void _getCurrentLocation() async{
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _locationMessage = '${position.latitude}, ${position.longitude}';
    });
    dialogBox.information(context, "Location", "$_locationMessage");
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
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Test"),
                accountEmail: Text("test123@abc.com"),
                currentAccountPicture: CircleAvatar(
                  child: Image.network('https://www.pngkit.com/png/full/281-2812821_user-account-management-logo-user-icon-png.png'),
                ),),
              ListTile(
                leading: Icon(Icons.file_upload),
                title: Text('Upload'),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return UploadPhotoImage();
                      })
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.location_searching),
                title: Text('Emergency'),
                onTap: (){_getCurrentLocation();},
              ),

              ListTile(
                leading: Icon(Icons.arrow_left),
                title: Text('SignOut', style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: _logoutUser,
              )
            ],
          ),
        ),
      ),
      floatingActionButton:
      Container(
        child: FloatingActionButton(
          child: Icon(Icons.add_a_photo,),
          tooltip: 'Upload a post',
          autofocus: true,
          clipBehavior: Clip.antiAlias,
          elevation: 5.0,
          splashColor: Colors.blue,
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
                            color: Colors.blue,
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://www.pngkit.com/png/full/281-2812821_user-account-management-logo-user-icon-png.png'
                              )
                            ),
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
              padding: const EdgeInsets.only(top: 5.0, bottom: 16.0, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://www.pngkit.com/png/full/281-2812821_user-account-management-logo-user-icon-png.png'
                          )
                      ),
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