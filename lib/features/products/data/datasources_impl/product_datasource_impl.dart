import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../products/domain/entities/product.dart'; // Domain Entity (Product)
import '../datasources/product_datasource.dart'; // Abstract Interface

class ProductDataSourceImpl implements ProductDataSource {
  final FirebaseFirestore _db;
  final String _collection = 'products';

  ProductDataSourceImpl(this._db);

  // --- Standard CRUD ---
  @override
  Future<String> addProduct(Product product) async {
    final doc = _db.collection(_collection).doc();
    await doc.set(product.toMap());
    return doc.id;
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _db.collection(_collection).doc(product.id).update(product.toMap());
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  @override
  Stream<List<Product>> streamProducts(String ownerId) {
    return _db
        .collection(_collection)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Product.fromMap(d.id, d.data())).toList());
  }

  // --- New Methods ---
  
  // Implements the method for the Stock Alert Usecase
  @override
  Stream<List<Product>> streamLowStockProducts(String ownerId) {
    // 💡 IMPORTANT: Since Firestore does not support 'where(qty < 10)', 
    // we stream all products for the user and apply the low-stock filter 
    // client-side, mirroring the original logic in stock_alert_service.dart.
    return _db
        .collection(_collection)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .where((p) => p.quantityInStock < 10) 
          .toList();
    });
  }

  // Implements the method for the Add Quantity Usecase
  @override
  Future<void> updateProductStock(String id, int newQuantity) async {
    await _db
        .collection(_collection)
        .doc(id)
        // Only update the specific field for efficiency and atomicity
        .update({'quantityInStock': newQuantity});
  }

  @override
  Uuid get uuid => throw UnimplementedError();
}