// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import '../../service/api.dart';
import '../widgets/pixel.dart';

class HomePage extends StatelessWidget {
  Widget _body() {
    var rfid = TextEditingController();
    return Center(
      child: Container(
        width: View.blockX * 40,
        height: View.blockY * 50,
        child: Row(
          children: [
            Flexible(
              flex: 5,
              child: TextFormField(
                controller: rfid,
                decoration: InputDecoration(
                  hintText: 'Cari RFID',
                  focusColor: Colors.blue,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: FlatButton(
                onPressed: () => Api.getUserInfo(rfid.text),
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
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton.extended(
      icon: Icon(Icons.add),
      label: Text('Buat Akun'),
      onPressed: () => UserDialog.createuser(),
    );
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
        body: _body(),
        floatingActionButton: _floatingActionButton(),
      ),
    );
  }
}
