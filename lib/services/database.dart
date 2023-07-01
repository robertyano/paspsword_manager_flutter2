import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paspsword_manager_flutter2/models/account.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid});

  // collection reference
  final CollectionReference accountCollection = FirebaseFirestore.instance.collection('accounts');


  Future<String> updateUserData(Account account) async {
    if (account.documentId.isEmpty) {
      // If the documentId is empty, create a new document with an auto-generated ID
      final newDoc = await accountCollection.doc(uid).collection('userAccounts').add({
        'accountName': account.accountName,
        'userName': account.userName,
        'password': account.password,
        'notes': account.notes,
      });
      return newDoc.id; // Return the ID of the newly created document
    } else {
      // If the documentId is not empty, update the existing document
      await accountCollection.doc(uid).collection('userAccounts').doc(account.documentId).set({
        'accountName': account.accountName,
        'userName': account.userName,
        'password': account.password,
        'notes': account.notes,
      });
      return account.documentId; // Return the existing document ID
    }
  }

  Future<void> deleteAccount(String documentId) async {
    await accountCollection.doc(uid).collection('userAccounts').doc(documentId).delete();
  }




  /*Future updateUserData(Account account) async {
    return await accountCollection.doc(uid).collection('userAccounts').doc(account.documentId).set({
      'accountName' : account.accountName,
      'userName' : account.userName,
      'password' : account.password,
      'notes' : account.notes,
    });
  }*/

  /*Future updateUserData(String accountName, String userName, String password, String notes) async {
    return await accountCollection.doc(uid).collection('userAccounts').add({
      'accountName' : accountName,
      'userName' : userName,
      'password' : password,
      'notes' : notes,
    });
  }*/

  // account list from snapshot
  List<Account> _accountListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Account(
        accountName: doc.get('accountName') ?? '',
        userName: doc.get('userName') ?? '',
        password: doc.get('password') ?? '',
        notes: doc.get('notes') ?? '',
        documentId: doc.id,
      );
    }).toList();
  }

  // get accounts stream
  Stream<List<Account>> get accounts {
    return accountCollection.doc(uid).collection('userAccounts').snapshots()
        .map(_accountListFromSnapshot);
  }
}
