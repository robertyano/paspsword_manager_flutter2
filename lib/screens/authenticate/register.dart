import 'package:flutter/material.dart';
import 'package:paspsword_manager_flutter2/services/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey <FormState>();

  // text field state
  String email = '';
  String password = '';
  String error = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.brown[100],
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            TextButton(
              child: const Text(
                'Back',
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white),

              ),
              onPressed: () {
                widget.toggleView();
              },
            ),
          ],
        ),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        child: Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                const SizedBox(height: 20.0,
                ),
                const FittedBox(
                  child: Text('Create an account for Password Secure Kiwi',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 25.0,
                ),
                TextFormField(
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
                SizedBox(height: 20.0),
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



                SizedBox(height: 20.0),
                ElevatedButton(
                    child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white)
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        if (result == null) {
                          setState(() => error = 'Please supply a valid email');
                        }
                      }
                    }
                ),
                SizedBox(height: 12.0),
                Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0)
                ),
              ]
          ),
        ),
      ),
    );
  }
}

