import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  //========= Class members ========//
  final String title;
//  final Function() onTap;

  const LoadingScreen({
    Key key,
    this.title,
  }) : super(key: key);

  //========= Class content ========//
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.transparent,
        content: Column(
          children: <Widget>[
            CircularProgressIndicator(
              strokeWidth: 10,
              backgroundColor: Color(0xFFc5e1a5),
            ),

            SizedBox(height: 5,),

            Text(title, style: TextStyle(color: Colors.white),)
          ],
        )
    );
  }
}