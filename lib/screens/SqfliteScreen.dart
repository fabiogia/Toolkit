// SqfliteScreen
import 'package:flutter/material.dart';
import '../widgets/DogsList.dart';

class SqfliteScreen extends StatefulWidget {
  SqfliteScreen({Key key}) : super(key: key);

  @override
  _SqfliteScreenState createState() => _SqfliteScreenState();
}

class _SqfliteScreenState extends State<SqfliteScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Sqflite'),
      ),
      body: DogsList()
    );
  }
}