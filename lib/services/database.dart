import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid});

  // collection reference
  final CollectionReference accountCollection = FirebaseFirestore.instance.collection('accounts');

  Future updateUserData(String accountName, String password, String notes) async {
    return await accountCollection.doc(uid).set({
      'accountName' : accountName,
      'password' : password,
      'notes' : notes,
    });
  }

}