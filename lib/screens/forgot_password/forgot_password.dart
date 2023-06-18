import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) =>
          Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Forgot Password'),
            ),
            body: Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          // code to execute if the value is null or empty
                          return 'Please enter an email';
                        } else {
                          // code to execute if the value is not null and not empty
                          return null;
                        }
                      },
                      onSaved: (value) => _email = value?.trim() ?? '',
                    ),
                    SizedBox(height: 20.0),
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: _email);
                            // show a success message to the user
                            Fluttertoast.showToast(
                                msg: "Success",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            //Navigate back to the previous screen
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });
                          } catch (error) {
                            // show an error message to the user
                            Fluttertoast.showToast(
                                msg: "Email not found.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            //Navigate back to the previous screen
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });

                          }
                        }
                      },
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
