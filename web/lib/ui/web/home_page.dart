// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import '../widgets/pixel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    // Timer.periodic(Duration(seconds: 3), (_) async => fetchData());
  }

  @override
  Widget build(BuildContext context) {
    View().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sistem Parkir'),
        ),
        body: Container(),
      ),
    );
  }
}
