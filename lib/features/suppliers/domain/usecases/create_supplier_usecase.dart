
// lib/features/supplier/domain/usecases/create_supplier_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/supplier.dart';
import '../repositories/supplier_repository.dart';

class CreateSupplierUsecase {
  final SupplierRepository repository;
  CreateSupplierUsecase(this.repository);
  Future<Either<Failure, String>> call(Supplier supplier) {
    return repository.createSupplier(supplier);
  }
}