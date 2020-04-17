import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppStatfull createState() => _MyAppStatfull();
}

class _MyAppStatfull extends State<MyApp> {
  String appName = 'Flutter E-Shop manager';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: appName),
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
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: typeListView,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

var layOutChallenge = Row(
  children: <Widget>[
    Container(
      color: Colors.red,
      width: 100,
    ),
    Expanded(
      child: Container(
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.yellow,
          ),
        ),
      ),
    ),
    Container(
      color: Colors.indigo,
      width: 100,
    ),
  ],
);

var typeListView = ListView(
  children: <Widget>[
    Card(
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text('Type name should be here'),
            ),
            Container(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.build),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
);
