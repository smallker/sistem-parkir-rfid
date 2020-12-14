// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web/controller/user_info_ctl.dart';
import 'package:web/service/api.dart';
import '../widgets/pixel.dart';

class UserInfoPage extends StatelessWidget {
  Widget _info() {
    return GetBuilder<UserInfoCtl>(
        init: UserInfoCtl(),
        builder: (snapshot) {
          return Container(
            padding: EdgeInsets.all(View.blockX * 1),
            width: View.blockX * 60,
            height: View.blockY * 75,
            child: ListView(
              children: [
                CustomCard(
                    icon: Icon(
                      Icons.qr_code_scanner,
                      size: View.blockX * 4,
                      color: Colors.white,
                    ),
                    title: 'RFID',
                    subtitle: snapshot.user.rfid),
                CustomCard(
                  icon: Icon(
                    Icons.person,
                    size: View.blockX * 4,
                    color: Colors.white,
                  ),
                  title: 'Nama',
                  subtitle: snapshot.user.name,
                ),
                CustomCard(
                  icon: Icon(
                    Icons.wallet_membership,
                    size: View.blockX * 4,
                    color: Colors.white,
                  ),
                  title: 'Saldo',
                  subtitle: 'Rp. ${snapshot.user.balance},-',
                ),
                CustomCard(
                  icon: Icon(
                    Icons.transit_enterexit,
                    size: View.blockX * 4,
                    color: Colors.white,
                  ),
                  title: 'Terakhir Entry',
                  subtitle: snapshot.user.lastEntry == 0
                      ? 'N/A'
                      : DateTime.fromMillisecondsSinceEpoch(
                              snapshot.user.lastEntry)
                          .toLocal()
                          .toString(),
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
                  onPressed: () => UserDialog.addBalance(),
                ),
              ],
            ),
          );
        });
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
          onPressed: () => Get.back(),
          label: Text('Kembali'),
          icon: Icon(
            Icons.keyboard_return,
          ),
        ),
      ),
    );
  }
}
