import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mooreview/dataProvider/dataService.dart';
import 'package:mooreview/pages/login.dart';
import 'package:mooreview/pages/mainPage.dart';

void main() => runApp(Bootstrap());

class Bootstrap extends StatefulWidget {
  @override
  _BootstrapState createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  final _storage = DataProvider.storage;

  void stateCheck(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: Future.wait(
            [_storage.read(key: "token"), _storage.read(key: "refresh")]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            if (snapshot.data[0] != null && snapshot.data[1] != null) {
              DataProvider().setTokenInClass(snapshot.data[0], snapshot.data[1]);
              return MainPage(stateCheck);
            }
          }
          return LoginPage(stateCheck);
        },
      ),
    );
  }
}
