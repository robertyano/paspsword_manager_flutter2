import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:paspsword_manager_flutter2/screens/wrapper.dart';
import 'package:paspsword_manager_flutter2/services/auth.dart';
import 'package:provider/provider.dart';
import 'models/theuser.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<theUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}

