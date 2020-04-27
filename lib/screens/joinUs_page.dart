import 'package:bmicalculator/components/loadingScreen.dart';
import 'package:bmicalculator/screens/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

import 'input_page.dart';

class JoinUs extends StatefulWidget {
  @override
  _JoinUsState createState() => _JoinUsState();
}

class _JoinUsState extends State<JoinUs> {
  //=======================================================//
  //===========  Class functions and variables  ===========//
  //=======================================================//
  String _email, _password;
  final _firestore = Firestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //=======================================================//
  //====================  UI elements  ====================//
  //=======================================================//
  onBottom(Widget child) => Positioned.fill(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: child,
    ),
  );
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
                      onPressed: _joinUs,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      child: Text('Join us'),
                    ),
                  ),

                ],
              ),
            )
        ),
    );
  }
  Future<void> _joinUs() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      //Loading screen
      showDialog(
          context: context,
          builder: (BuildContext context){
            return LoadingScreen(title: 'Signing up...',);
          }
      );

      try{
        FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        await _firebaseAuth.createUserWithEmailAndPassword(email: _email, password: _password);
        AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);

        //Setting user vars
        final FirebaseUser _firebaseUser = await _firebaseAuth.currentUser();
        email = _firebaseUser.email;


        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InputPage()));
      }catch(error){
        Navigator.pop(context);
        if(error is PlatformException){
          if(error.code == 'ERROR_EMAIL_ALREADY_IN_USE'){
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
                              'Email already in use', textScaleFactor: 1.1,
                            ),
                            FlatButton(
                              child: Text(
                                  'Ok', textScaleFactor: 1.1,
                                  style: TextStyle(
                                    color: Color(0xFFFFA4FF),
                                  )
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
}
