import 'package:paspsword_manager_flutter2/models/theuser.dart';
import 'package:paspsword_manager_flutter2/screens/authenticate/authenticate.dart';
import 'package:paspsword_manager_flutter2/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<theUser?>(context);
    print(user);

    // return either Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return Home();
    }
  }
}
