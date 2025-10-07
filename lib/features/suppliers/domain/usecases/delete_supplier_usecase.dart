import '../repositories/supplier_repository.dart';

class DeleteSupplierUsecase {
  final SupplierRepository _repository;
  DeleteSupplierUsecase(this._repository);
  Future<void> call(String id) {
    return _repository.deleteSupplier(id);
  }
}