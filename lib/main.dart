import 'package:flutter/material.dart';
import 'package:flutter_auth2/add_note_page.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/loginpage' : (context) => LoginPage(),
        '/homepage' : (context) => HomePage(),
        '/addnote' : (context) => AddNote(),
      },
    );
  }
}
