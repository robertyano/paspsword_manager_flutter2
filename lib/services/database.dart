import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paspsword_manager_flutter2/models/account.dart';
import 'package:encrypt/encrypt.dart';

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

  // Update getEncryptionKey to dynamically fetch the encryption key from Firestore
  Future<String?> getEncryptionKey() async {
    try {
      final keySnapshot = await accountCollection
          .doc(uid)
          .collection('encryptionKeys')
          .get();
      print("database.dart vid: " + uid);

      // If the query returns any documents, get the encryption key from the first document
      if (keySnapshot.docs.isNotEmpty) {
        final encryptionKey = keySnapshot.docs.first.get('key') as String?;
        return encryptionKey;
      } else {
        // If the query does not return any documents, it means the encryption key does not exist
        print("Encryption key not found for the user.");

        // You may handle this situation accordingly, for example, by generating and saving a new encryption key.
        // For this example, we will return null when the encryption key is not found.
        return null;
      }
    } catch (e) {
      print("Error retrieving encryption key: ${e.toString()}");
      return null;
    }
  }




  Future<String> updateUserData(Account account) async {
    // Check if the encryption key is available in the Firestore
    String? encryptionKey = await getEncryptionKey();
    print("Encryption key: $encryptionKey"); // Print the retrieved encryption key

    // If encryption key is not available, return an error or handle the situation accordingly
    if (encryptionKey == null || encryptionKey.isEmpty) {
      throw Exception("Encryption key not found for the user.");
    }

    // Initialize the encryption key and IV (Initialization Vector)
    final key = Key.fromUtf8(encryptionKey);
    final iv = IV.fromLength(16);

    // Encrypt the password using AES encryption
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encryptedPassword = encrypter.encrypt(account.password, iv: iv);

    if (account.documentId.isEmpty) {
      // If the documentId is empty, create a new document with an auto-generated ID
      final newDoc = await accountCollection.doc(uid).collection('userAccounts').add({
        'accountName': account.accountName,
        'userName': account.userName,
        'password': encryptedPassword.base64, // Save the encrypted password as a Base64-encoded string
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
        'password': encryptedPassword.base64, // Save the encrypted password as a Base64-encoded string
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
