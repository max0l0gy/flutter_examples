import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  return runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ask me anything'),
          backgroundColor: Colors.blueGrey,
        ),
        body: BallPage(),
      ),
    ),
  );
}

class BallPage extends StatefulWidget {
  @override
  _BallPageState createState() => _BallPageState();
}

class _BallPageState extends State<BallPage> {
  int ballIdx = 1;

  void changeOpinion() {
    setState(() {
      ballIdx = Random().nextInt(5) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              onPressed: () {
                changeOpinion();
              },
              child: Image.asset('images/ball$ballIdx.png'),
            ),
          ),
        ],
      ),
    );
  }
}
