import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paspsword_manager_flutter2/models/theuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:paspsword_manager_flutter2/services/database.dart';

import '../models/account.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  theUser? _userFromFirebaseUser2(User? user, Account userAccount) {
    return user != null ? theUser(uid: user.uid) : null;
  }

  theUser? _userFromFirebaseUser(User? user) {
    return user != null ? theUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<theUser?> get user {
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }


  // sign in anon -> no longer required
 /* Future signInAnon() async {
    await Firebase.initializeApp();
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }*/

  // Sign in with Email and Password
  Future<theUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Get the user's encryption key from Firestore
      String encryptionKey = await _getEncryptionKey(user!.uid);

      // Create the user's account with the retrieved key
      Account userAccount = Account(accountName: '', userName: '', password: '', notes: '', documentId: '', encryptionKey: encryptionKey);

      return _userFromFirebaseUser2(user, userAccount);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> _getEncryptionKey(String uid) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('accounts').doc(uid).collection('encryptionKeys').doc(uid).get();
    return snapshot.exists ? snapshot['key'] : '';
  }



// register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Check if the account already exists for the user
      bool accountExists = await DatabaseService(uid: user!.uid).checkAccountExists();
      if (!accountExists) {
        // Create a new document for that user with the uid
        /*Account newAccount = Account(accountName: 'new account', userName: 'new username', password: 'new password', notes: '', documentId: '', encryptionKey: ''); // create new Account object
        await DatabaseService(uid: user.uid).updateUserData(newAccount); // pass the Account object
        return _userFromFirebaseUser2(user, newAccount);*/
        return _userFromFirebaseUser(user);
      } else {
        // Account already exists, return the user without creating a new account
        return _userFromFirebaseUser(user);
      }
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  Future<bool> deleteAccount() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Delete all user accounts
        await _deleteUserAccounts(currentUser.uid);

        // Delete the user account
        await currentUser.delete();

        return true; // Account deleted successfully
      } catch (e) {
        print(e.toString());
        return false; // Failed to delete account
      }
    } else {
      return false; // User not authenticated
    }
  }

  Future<void> _deleteUserAccounts(String uid) async {
    final accountCollection = FirebaseFirestore.instance.collection('accounts');
    final querySnapshot = await accountCollection.doc(uid).collection('userAccounts').get();
    final batch = FirebaseFirestore.instance.batch();
    querySnapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });

    // Call the function to delete encryptionKeys associated with the user
    await _deleteEncryptionKeys(uid);

    await batch.commit();
  }

  Future<void> _deleteEncryptionKeys(String uid) async {
    final encryptionKeysCollection = FirebaseFirestore.instance.collection('accounts').doc(uid).collection('encryptionKeys');
    final querySnapshot = await encryptionKeysCollection.get();
    final batch = FirebaseFirestore.instance.batch();
    querySnapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });
    await batch.commit();
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