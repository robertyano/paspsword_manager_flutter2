import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paspsword_manager_flutter2/models/account.dart';

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

  // account list from snapshot
  List<Account> _accountListFromSnapshot(QuerySnapshot snapshot) {
      return snapshot.docs.map((doc){
        return Account(
            accountName: doc.get('accountName') ?? '',
            password: doc.get('password') ?? '',
            notes: doc.get('notes') ?? ''
        );
      }).toList();
  }

  // get accounts stream
  Stream<List<Account>> get accounts {
    return accountCollection.snapshots()
        .map(_accountListFromSnapshot);

  }

}