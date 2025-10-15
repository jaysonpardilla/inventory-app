// lib/features/transactions/data/repositories_impl/transaction_repository_impl.dart
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/entities/transaction.dart';
import '../datasources/transaction_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDataSource dataSource;

  TransactionRepositoryImpl(this.dataSource);

  @override
  Stream<List<InventoryTransaction>> streamTransactions(String ownerId) {
    // Simple pass-through for stream data from the data source
    return dataSource.streamTransactions(ownerId);
  }
}