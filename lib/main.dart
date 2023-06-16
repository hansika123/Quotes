import 'package:flutter/material.dart';
import 'loginpage.dart';
import './home.dart';
import 'pocketbase/configs.dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) {
          if (Auth.authToken != null) {
            return HomePage(token: Auth.authToken!);
          } else {
            return LoginPage();
          }
        },
      },
    );
  }
}
