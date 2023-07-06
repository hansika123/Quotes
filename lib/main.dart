import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'favorites.dart';
import 'loginpage.dart';
import './home.dart';
import 'models/fav_quotes.dart';
import 'navbar.dart';
import 'pocketbase/configs.dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) {
          if (Auth.authToken != null) {
            return HomePage(token: Auth.authToken!);
          } else {
            return LoginPage();
          }
        },
        '/favorites': (context) => FavoritePage(
              token: Auth.authToken!,
              currentIndex: 1,
            ),
      },
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => _getScreen(settings.name!),
                );
              },
            ),
            bottomNavigationBar: BottomNavigationBarWidget(
              currentIndex: 0,
              onTap: (int index) {
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, '/home');
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/favorites');
                    break;
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _getScreen(String routeName) {
    switch (routeName) {
      case '/':
        return LoginPage();
      case '/home':
        return HomePage(token: Auth.authToken!);
      case '/favorites':
        return FavoritePage(
          token: Auth.authToken!,
          currentIndex: 1,
        );
      default:
        return LoginPage();
    }
  }
}
