class Account {

  final String accountName;
  final String userName;
  final String password;
  final String notes;
  final String documentId;
  final String? encryptionKey;

  Account({required this.accountName, required this.userName, required this.password, required this.notes, required this.documentId, this.encryptionKey});

}