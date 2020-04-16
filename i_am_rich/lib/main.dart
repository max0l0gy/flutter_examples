import 'package:flutter/material.dart';

//The main function is the starting point for all our apps.
void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey[700],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[800],
          title: Text("I Am Rich"),
        ),
        body: Center(
          child: const Image(
            image: AssetImage('images/diamond.png'),
          ),
        ),
      ),
    ),
  );
}
