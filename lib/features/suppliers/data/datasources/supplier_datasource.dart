// lib/features/suppliers/data/datasources/supplier_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config.dart';
// Updated import to the new Entity location
import '../../domain/entities/supplier.dart'; 

class SupplierDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Suppliers Stream
  Stream<List<Supplier>> streamSuppliers(String ownerId) {
    return _db
        .collection(Config.suppliersCollection)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Supplier.fromMap(d.id, d.data())).toList());
  }

  // 🔹 Get Supplier By ID (Added utility for detail screen)
  Future<Supplier?> getSupplierById(String id) async {
    final doc = await _db.collection(Config.suppliersCollection).doc(id).get();
    if (doc.exists && doc.data() != null) {
      return Supplier.fromMap(doc.id, doc.data()!);
    }
    return null;
  }

  // 🔹 Add Supplier
  Future<String> addSupplier(Supplier supplier) async {
    final doc = _db.collection(Config.suppliersCollection).doc();
    await doc.set(supplier.toMap());
    return doc.id;
  }

  // 🔹 Update Supplier
  Future<void> updateSupplier(Supplier supplier) async {
    await _db
        .collection(Config.suppliersCollection)
        .doc(supplier.id)
        .update(supplier.toMap());
  }

  // 🔹 Delete Supplier
  Future<void> deleteSupplier(String id) async {
    await _db.collection(Config.suppliersCollection).doc(id).delete();
  }
}