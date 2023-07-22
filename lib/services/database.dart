import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paspsword_manager_flutter2/models/account.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid});

  // collection reference
  final CollectionReference accountCollection = FirebaseFirestore.instance.collection('accounts');

  Future<bool> checkAccountExists() async {
    try {
      final userAccountsCollection = FirebaseFirestore.instance.collection('accounts').doc(uid).collection('userAccounts');
      final querySnapshot = await userAccountsCollection.limit(1).get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }


  Future<String> updateUserData(Account account) async {
    if (account.documentId.isEmpty) {
      // If the documentId is empty, create a new document with an auto-generated ID
      final newDoc = await accountCollection.doc(uid).collection('userAccounts').add({
        'accountName': account.accountName,
        'userName': account.userName,
        'password': account.password,
        'notes': account.notes,
      });

      // Save the encryption key in a separate document if it is not empty
      if (account.encryptionKey!.isNotEmpty) {
        await accountCollection.doc(uid).collection('encryptionKeys').doc(newDoc.id).set({
          'key': account.encryptionKey,
        });
      }
      return newDoc.id; // Return the ID of the newly created document
    } else {
      // If the documentId is not empty, update the existing document
      await accountCollection.doc(uid).collection('userAccounts').doc(account.documentId).set({
        'accountName': account.accountName,
        'userName': account.userName,
        'password': account.password,
        'notes': account.notes,
      });

      // Save the encryption key in a separate document if it is not empty
      if (account.encryptionKey!.isNotEmpty) {
        await accountCollection.doc(uid).collection('encryptionKeys').doc(account.documentId).set({
          'key': account.encryptionKey,
        });
      }
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
        encryptionKey: 'encryptionKey',
      );
    }).toList();
  }

  // get accounts stream
  Stream<List<Account>> get accounts {
    return accountCollection.doc(uid).collection('userAccounts').snapshots()
        .map(_accountListFromSnapshot);
  }
}
