import 'package:appprojetoitinerante/app/views/home_page.dart';
import 'package:appprojetoitinerante/app/views/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home_page':(context) => HomePage(),
        '/login':(context) => LoginPage(),
      },
      initialRoute: '/home_page',
    );
  }
}