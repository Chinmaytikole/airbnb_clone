import 'package:flutter/material.dart';
import 'main.dart';
import 'home.dart';// Import home.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airbnb Clone',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/main': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),// Route for HomePage
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeefffc),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.lock,
                  size: 100,
                  color: Color(0xff00ffd9),
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00ffd9),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Log in to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
                SizedBox(height: 40),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(color: Color(0xff000000)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Color(0xff000000)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff000000)),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/home'); // Redirect to HomePage
                            },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff00ffd9),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.facebook, color: Colors.blue),
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/home'); // Redirect to HomePage
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.g_translate, color: Color(0xff00ffd9)),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/home'); // Redirect to HomePage
                                },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/main'); // Redirect to HomePage
                            },
                            child: Text(
                              'Don’t have an account? Sign Up',
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
