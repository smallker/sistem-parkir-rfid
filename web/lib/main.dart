import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'ui/web/home_page.dart';

void main() => runApp(
      LoadingProvider(
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sistem Parkir',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
