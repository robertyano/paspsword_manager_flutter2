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
    return loading ? Loading() : Scaffold(  // scaffolds implement the basic Material Design visual layout structure
      // class provies APIs for showing drawers and bottom sheet
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Password Secure Kiwi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height, // Attempt to fix, bring back if necessary
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
          child: Form(
            key: _formKey,
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch, //Attempt to fix, delete if necessary
                children: <Widget>[
                  AspectRatio(aspectRatio: 1, child: Image.asset('assets/evil_kiwi_bird_tattoo_design.png', fit: BoxFit.fitWidth),),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal:15),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: 400.0,
                    child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                          // labelText: 'Email',
                        ),
                        validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 0, bottom: 0),
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Password',
                      ),
                      validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      }
                  ),
                  TextButton(
                    onPressed: (){
                      //TODO FORGOT PASSWORD SCREEN GOES HERE
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
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                        child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 25)
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
                        }
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: (){
                        //TODO Register new user
                        widget.toggleView();
                      },
                      child: const Text(
                        'New User? Create Account',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),

                  // Text(
                  //     error,
                  //     style: const TextStyle(color: Colors.red, fontSize: 14.0)
                  // ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
