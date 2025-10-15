import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/supplier.dart';
import '../datasources/supplier_datasource.dart';

class SupplierDataSourceImpl implements SupplierDataSource {
  final FirebaseFirestore _db;
  final String _collection = 'suppliers';

  SupplierDataSourceImpl(this._db);

  @override
  Future<String> addSupplier(Supplier supplier) async {
    final doc = _db.collection(_collection).doc();
    await doc.set(supplier.toMap());
    return doc.id;
  }

  @override
  Future<void> updateSupplier(Supplier supplier) async {
    await _db.collection(_collection).doc(supplier.id).update(supplier.toMap());
  }

  @override
  Future<void> deleteSupplier(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  @override
  Stream<List<Supplier>> streamSuppliers(String ownerId) {
    return _db
        .collection(_collection)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Supplier.fromMap(d.id, d.data()))
            .toList());
  } 

  // 💡 ADD THIS LINE TO YOUR INTERFACE
  @override
  Future<Supplier?> getSupplierById(String id) async {
    final doc = await _db.collection(_collection).doc(id).get();
    return doc.exists ? Supplier.fromMap(doc.id, doc.data()!) : null;
  }
}