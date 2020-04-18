import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gu_bulletin/mapping.dart';
import 'authentication.dart';
import 'screens/home.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoginPage',
      home: MappingPage(auth: Auth(),),
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.tealAccent,
          brightness: Brightness.light),
    );
  }
}

