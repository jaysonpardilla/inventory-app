// lib/features/supplier/domain/usecases/stream_suppliers_usecase.dart
import '../../domain/entities/supplier.dart';
import '../repositories/supplier_repository.dart';

class StreamSuppliersUsecase {
  final SupplierRepository repository;
  StreamSuppliersUsecase(this.repository);
  Stream<List<Supplier>> call(String ownerId) {
    return repository.streamSuppliers(ownerId);
  }
}
