// lib/features/suppliers/domain/repositories/supplier_repository.dart
import '../../../../core/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/supplier.dart';

abstract class SupplierRepository {
  // Returns a stream of all suppliers for the owner
  Stream<List<Supplier>> streamSuppliers(String ownerId);

  // Retrieves a single supplier entity by ID
  Future<Either<Failure, Supplier>> getSupplierDetails(String id);

  // Creates a new supplier
  Future<Either<Failure, String>> createSupplier(Supplier supplier);

  // Updates an existing supplier
  Future<Either<Failure, void>> updateSupplier(Supplier supplier);

  // Deletes a supplier by ID
  Future<Either<Failure, void>> deleteSupplier(String id);
}