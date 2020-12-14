// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:web/service/api.dart';
import '../widgets/pixel.dart';

class UserInfoPage extends StatelessWidget {
  Widget _info() {
    return Container(
      padding: EdgeInsets.all(View.blockX * 1),
      width: View.blockX * 60,
      height: View.blockY * 75,
      child: ListView(
        children: [
          CustomCard(
              icon: Icon(
                Icons.confirmation_number,
                size: View.blockX * 4,
                color: Colors.white,
              ),
              title: 'RFID',
              subtitle: '198381902890'),
          CustomCard(
            icon: Icon(
              Icons.person,
              size: View.blockX * 4,
              color: Colors.white,
            ),
            title: 'Nama',
            subtitle: 'Wahyu Hidayat',
          ),
          CustomCard(
            icon: Icon(
              Icons.wallet_membership,
              size: View.blockX * 4,
              color: Colors.white,
            ),
            title: 'Saldo',
            subtitle: 'Rp. 10 000,-',
          ),
          CustomCard(
            icon: Icon(
              Icons.transit_enterexit,
              size: View.blockX * 4,
              color: Colors.white,
            ),
            title: 'Terakhir Entry',
            subtitle: '14 Desember 2020 13.31',
          ),
          FlatButton.icon(
            color: Colors.blue,
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: View.blockX * 5,
            ),
            label: Text(
              'Tambah Saldo',
              style: TextStyle(
                color: Colors.white,
                fontSize: View.blockX * 3,
              ),
            ),
            onPressed: () => print('tambah saldo'),
          ),
        ],
      ),
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
        body: Center(
          child: _info(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => UserDialog().notFound(),
          label: Text('Kembali'),
          icon: Icon(
            Icons.keyboard_return,
          ),
        ),
      ),
    );
  }
}
