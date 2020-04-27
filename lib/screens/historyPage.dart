import 'package:bmicalculator/screens/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _firestore = Firestore.instance;
  Stream<QuerySnapshot> get _queryHistory =>
      _firestore.collection('history')
          .where('userEmail', isEqualTo: email)
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),

      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9, minHeight: 0),
          child: FirestoreAnimatedList(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            query: _queryHistory,
            onLoaded: (snapshot) =>
                print("Received on list: ${snapshot.documents.length}"),
            itemBuilder: (
                BuildContext context,
                DocumentSnapshot snapshot,
                Animation<double> animation,
                int index,
                ) => FadeTransition(
                  opacity: animation,
                  child: ListTile(
                    title: Text('BMI: ' + snapshot['bmi']),

                    subtitle: Text(snapshot['date'].substring(0,4)  + '-' + snapshot['date'].substring(4,6) + '-' + snapshot['date'].substring(6,8)),
                  )
//                UserListTile(
//                  index: index,
//                  document: snapshot,
//                )
            ),
          )
      ),
    );
  }
}
