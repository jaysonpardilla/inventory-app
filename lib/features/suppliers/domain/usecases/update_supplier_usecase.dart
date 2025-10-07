import '../entities/supplier.dart';
import '../repositories/supplier_repository.dart';

class UpdateSupplierUsecase {
  final SupplierRepository _repository;
  UpdateSupplierUsecase(this._repository);
  Future<void> call(Supplier supplier) {
    return _repository.updateSupplier(supplier);
  }
}