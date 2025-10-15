// lib/features/transactions/data/datasources/transaction_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config.dart';
// Updated import to the new Entity location
import '../../domain/entities/transaction.dart'; 

class TransactionDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Transactions Stream
  Stream<List<InventoryTransaction>> streamTransactions(String ownerId) {
    return _db
        .collection(Config.transactionsCollection)
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('transactionDate', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => InventoryTransaction.fromMap(d.id, d.data()))
            .toList());
  }
}