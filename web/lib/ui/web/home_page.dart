// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web/ui/web/user_info_page.dart';
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
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: View.blockX * 30,
            height: View.blockY * 40,
            child: Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Cari RFID',
                      focusColor: Colors.blue,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: FlatButton(
                    onPressed: () => Get.to(UserInfoPage()),
                    child: Icon(
                      Icons.search,
                      color: Colors.blue,
                      size: View.blockX * 4,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
