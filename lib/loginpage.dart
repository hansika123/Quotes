import 'package:flutter/material.dart';
import 'pocketbase/configs.dart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String token = '';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final isAuthenticated = await Auth.authenticate(username, password);

    if (isAuthenticated.isValid) {
      print('Successfully logged in');
      print('Token: ${isAuthenticated.token}');
      Navigator.pushReplacementNamed(context, '/home');
      token = isAuthenticated.token!;
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Text(
                  'Welcome',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Image.asset(
                  'assets/moon.png',
                  height: 110,
                  width: 110,
                ),
                const SizedBox(height: 60),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 20.0),
                        child: Icon(
                          FontAwesomeIcons.user,
                          color: Colors.grey,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      )),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 20.0),
                        child: Icon(
                          FontAwesomeIcons.lock,
                          color: Colors.grey,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      )),
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 55,
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () => _login(context),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0)),
                        backgroundColor: Colors.black),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
