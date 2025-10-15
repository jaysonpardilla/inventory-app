// lib/features/suppliers/data/repositories_impl/supplier_repository_impl.dart
import 'package:dartz/dartz.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/repositories/supplier_repository.dart';
import '../../domain/entities/supplier.dart';
import '../datasources/supplier_datasource.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierDataSource dataSource;

  SupplierRepositoryImpl(this.dataSource);

  @override
  Stream<List<Supplier>> streamSuppliers(String ownerId) {
    return dataSource.streamSuppliers(ownerId);
  }

  @override
  Future<Either<Failure, Supplier>> getSupplierDetails(String id) async {
    try {
      final supplier = await dataSource.getSupplierById(id);
      if (supplier != null) {
        return Right(supplier);
      }
      return const Left(ServerFailure(message: 'Supplier not found.'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createSupplier(Supplier supplier) async {
    try {
      final id = await dataSource.addSupplier(supplier);
      return Right(id);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSupplier(Supplier supplier) async {
    try {
      await dataSource.updateSupplier(supplier);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSupplier(String id) async {
    try {
      await dataSource.deleteSupplier(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}