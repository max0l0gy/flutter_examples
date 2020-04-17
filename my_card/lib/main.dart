import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Card',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                'https://drive.google.com/uc?export=download&id=1ChxJLqsybnLkdtJBlhIkrBxvcEGllv4Y',
              ),
            ),
            Text(
              'Maxim Morev',
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 23,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'PressStart2P',
              ),
            ),
            Text(
              'Senior Java Developer',
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 23,
                color: Colors.teal.shade100,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
                fontFamily: 'Saira',
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 25.0,
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.phone,
                    color: Colors.teal,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '+7 926 392 63 69',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Saira',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 25.0,
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Colors.teal,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'maxmorev@gmail.com',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Saira',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
