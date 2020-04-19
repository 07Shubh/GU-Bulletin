import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gu_bulletin/authentication.dart';
import 'package:gu_bulletin/dialogbox.dart';
import 'package:gu_bulletin/screens/home.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    this.auth,
    this.onSignedIn,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType{
  login
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  DialogBox dialogBox = DialogBox();
  final _formType = FormType.login;
  String _email="", _password="";

  StreamSubscription<DataConnectionStatus> listener;

  @override
  void dispose() async{
    listener.cancel();
    super.dispose();
  }
  checkInternet() async{
    print("The statement 'this machine is connected to the Internet' is: ");
    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum value instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    // this will cause DataConnectionChecker to check periodically
    // with the interval specified in DataConnectionChecker().checkInterval
    // until listener.cancel() is called
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });

    // close listener after 30 seconds, so the program doesn't run forever
    return await DataConnectionChecker().connectionStatus;
  }

  //method
  bool validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
}
void validateAndSubmit()async{
    DataConnectionStatus status = await checkInternet();
    if(status == DataConnectionStatus.connected) {
      if (validateAndSave()) {
        try {
          if (_formType == FormType.login) {
            String userId = await widget.auth.signIn(_email, _password);
            //dialogBox.information(context, "Congratulations", "You are logged in successfully!");
            print("login user ID" + userId);
          }
          else {
            dialogBox.information(context, "Invalid Username or Password", "");
            print("Invalid ID or password");
          }
          widget.onSignedIn();
        }

        catch (e) {
          dialogBox.information(context, "Error: ", e.toString());
          print("Error:" + e.toString());
        }
      }
    }
    else{
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("No Internet"),
          content: Text("Check your internet connection"),
        )
      );
    }

}


  //design
  AnimationController _iconanimationController;
  Animation<double> _iconanimation;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _iconanimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    );
    _iconanimation = CurvedAnimation(
        parent: _iconanimationController,
        curve: Curves.easeOut
    );
    _iconanimation.addListener(() => this.setState(() {}));
    _iconanimationController.forward();
  }
  Widget getImageAsset() {
    AssetImage assetImage = AssetImage("images/gal.png");
    Image image = Image(
      image: assetImage,
      width: _iconanimation.value * 150,
      height: _iconanimation.value * 150,
    );
    return Container(
      child: image,
      padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage("images/galo.jpg"),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          ListView(
            padding: EdgeInsets.only(top: 120.0),
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getImageAsset(),
              //FlutterLogo(
                //size: _iconanimation.value * 100,
              //),
              Form(
                key: _formKey,
                  child: Theme(
                      data: ThemeData(
                          brightness: Brightness.dark,
                          primarySwatch: Colors.teal,
                          inputDecorationTheme: InputDecorationTheme(
                              labelStyle: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 20.0
                              )
                          )
                      ),
                      child: Container(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              // ignore: missing_return
                              validator: (input){
                                if(input.isEmpty) {
                                  return 'Please enter the Email';
                                }
                              },
                              onSaved: (input) => _email = input,
                              decoration: InputDecoration(
                                hintText: 'Enter username',
                                labelText: 'Username',
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            Padding(padding: EdgeInsets.all(10.0)),
                            TextFormField(
                              // ignore: missing_return
                              validator: (input){
                                if(input.isEmpty) {
                                  return 'Please enter the password';
                                }
                              },
                              onSaved: (input) => _password = input,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter password',
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                            ),
                            Padding(padding: EdgeInsets.all(20.0),),
                            MaterialButton(
                              color: Colors.teal,
                              textColor: Colors.white,
                              child: Text('Login'),
                              onPressed: validateAndSubmit,
                              splashColor: Colors.tealAccent,
                            )
                          ],
                        ),
                      ))
              )
            ],
          )
        ],
      ),
    );
  }
/*
  Future<void> signIn() async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        dynamic result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        if(result == null){
          setState(() => error = 'could not sign in with these credentials');
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      }catch(e){
        print(e.message);
      }
    }
  } */
}

