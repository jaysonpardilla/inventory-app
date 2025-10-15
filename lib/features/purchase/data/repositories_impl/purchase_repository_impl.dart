// lib/features/purchase/data/repositories_impl/purchase_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../datasources/purchase_datasource.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseDataSource dataSource;

  PurchaseRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> createPurchaseTransaction({
    required String ownerId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      // This single call encapsulates the complex multi-step Firestore transaction
      await dataSource.createPurchaseTransaction(ownerId: ownerId, items: items);
      return const Right(null);
    } catch (e) {
      // Since this is a complex transaction, specific exceptions should be caught 
      // (like insufficient stock) and mapped to a Failure type.
      return Left(ServerFailure(message: e.toString()));
    }
  }
}