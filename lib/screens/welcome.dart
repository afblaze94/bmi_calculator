import 'package:bmicalculator/components/loadingScreen.dart';
import 'package:bmicalculator/screens/joinUs_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';
import 'input_page.dart';

//===== GLOBALS =====//
String email;
class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  //=======================================================//
  //===========  Class functions and variables  ===========//
  //=======================================================//
  String _email, _password;
  final _firestore = Firestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //=======================================================//
  //====================  UI elements  ====================//
  //=======================================================//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Sign in',
                    textScaleFactor: 2.5,
                  ),

                  SizedBox(height: 100,),

                  TextFormField(    //Email
                    validator: (input){
                      if(input.isEmpty || !isEmail(input)){
                        return 'Please enter a valid email';
                      }
                    },
                    onSaved: (input) => _email = input,
                    decoration: InputDecoration(
                        labelText: "Email"
                    ),
                  ),

                  SizedBox(   //For spacing out text fields (reused)
                    height: 20,),

                  TextFormField(    //Password
                    validator: (input){
                      if(input.length < 6){
                        return 'Please enter password of length > 6';
                      }
                    },
                    onSaved: (input) => _password = input,
                    decoration: InputDecoration(
                        labelText: "Password"
                    ),
                    obscureText: true,
                  ),

                  SizedBox(height: 30,),

                  SizedBox(
                    width: 200,
                    child: RaisedButton(
                      onPressed: _signIn,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      child: Text('Sign in'),
                    ),
                  ),

                  SizedBox(
                    width: 200,
                    child: RaisedButton(
                      onPressed: _joinUs,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      child: Text('Join us'),
                    ),
                  ),

                  SizedBox(
                      width: 200,
                      child: RaisedButton(
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                        ),
                        onPressed: _resetPassword,
                        child: Text('Forgot password'),
                      )
                  ),
                ],
              ),
            )
        ),
    );
  }

  Future<void> _signIn() async {
    final _formState = _formKey.currentState;
    if(_formState.validate()) {
      _formState.save();

      //Loading screen
      showDialog(
          context: context,
          builder: (BuildContext context){
            return LoadingScreen(title: 'Logging in...',);
          }
      );

      try{
        FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);

        FirebaseUser _firebaseUser = await _firebaseAuth.currentUser();
        print('Logged in');
        email = _firebaseUser.email;

        //Push main page
        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => InputPage()));
      }
      catch(error){
        Navigator.pop(context);
        if(error is PlatformException){
          if(error.code == 'ERROR_USER_NOT_FOUND' || error.code == 'ERROR_WRONG_PASSWORD'){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                      title: Text('Error', textScaleFactor: 1.1),
                      content: Container(
                        height: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              error.code == 'ERROR_USER_NOT_FOUND'?'Invalid email':'Wrong password', textScaleFactor: 1.1,
                            ),
                            FlatButton(
                              child: Text(
                                'Ok', textScaleFactor: 1.1,
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      )
                  );
                }
            );
          }
        }
      }
    }
  }

  Future<void> _resetPassword() async {
    final _formState = _formKey.currentState;
    _formState.save();
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
  }

  void _joinUs(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => JoinUs(),
        fullscreenDialog: true));
  }
}
