import 'package:paspsword_manager_flutter2/screens/authenticate/register.dart';
import 'package:paspsword_manager_flutter2/services/auth.dart';  // import authentication service to see if user needs to sign-in or register new account
import 'package:paspsword_manager_flutter2/shared/loading.dart';
import 'package:flutter/material.dart';  // import material library with many design components
import 'package:firebase_core/firebase_core.dart';

import '../forgot_password/forgot_password.dart';  // import the firebase_core plugin

class SignIn extends StatefulWidget {
  // const SignIn({Key? key}) : super(key: key);

  final Function toggleView; // create function that will update view
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService(); // service to connect and review if Firebase instance exists
  final _formKey = GlobalKey <FormState>();
  bool loading = false;

  // text field state initialization
  String email = '';
  String password = '';
  String error = '';
  // text field state initialization

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Password Secure Kiwi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: screenHeight * 0.35,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset('assets/evil_kiwi_logo.jpg', fit: BoxFit.fitWidth),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Password',
                      ),
                      validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: FORGOT PASSWORD SCREEN GOES HERE
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Could not sign in with those credentials';
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      // TODO: Register new user
                      widget.toggleView();
                    },
                    child: const Text(
                      'New User? Create Account',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
