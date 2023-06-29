import 'package:paspsword_manager_flutter2/models/theuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:paspsword_manager_flutter2/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  theUser? _userFromFirebaseUser(User? user) {
    return user != null ? theUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<theUser?> get user {
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }


  // sign in anon
  Future signInAnon() async {
    await Firebase.initializeApp();
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // create a new document for that user with the uid
      await DatabaseService(uid: user!.uid).updateUserData('new account', 'new password', '');
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}