import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

void main() {
  return runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text('Dicee'),
          backgroundColor: Colors.red,
        ),
        body: DicePage(),
      ),
    ),
  );
}

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

class RandomDice {
  var rendom = Random();
  int nextDice() {
    return rendom.nextInt(6) + 1;
  }
}

class _DicePageState extends State<DicePage> {
  var leftDiceNumber = RandomDice().nextDice();
  var rightDiceNumber = RandomDice().nextDice();
  var random = RandomDice();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: FlatButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  setState(() {
                    leftDiceNumber = random.nextDice();
                    print('Left dicee got pressed $leftDiceNumber');
                  });
                },
                child: Image.asset('images/dice$leftDiceNumber.png'),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: FlatButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  setState(() {
                    rightDiceNumber = random.nextDice();
                    print('Right dicee got pressed $rightDiceNumber');
                  });
                },
                child: Image.asset('images/dice$rightDiceNumber.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
