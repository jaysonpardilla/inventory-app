// lib/features/products/data/datasources/firebase_product_datasource.dart (CORRECTED)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/config.dart';
import '../../domain/entities/product.dart';
import 'product_datasource.dart';

// This is the CONCRETE (non-abstract) implementation.
class FirebaseProductDataSource implements ProductDataSource {
  // 1. Instantiate the fields here
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  @override
  Uuid get uuid => _uuid;

  // 2. Implement streamProducts (Fixing the previous UnimplementedError)
  @override
  Stream<List<Product>> streamProducts(String userId) {
    return _db
        .collection(Config.productsCollection)
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Product.fromMap(d.id, d.data())).toList());
  }

  // 3. Implement addProduct
  @override
  Future<String> addProduct(Product product) async {
    final doc = _db.collection(Config.productsCollection).doc();
    await doc.set(product.toMap()); 
    return doc.id;
  }

  // 4. Implement updateProduct
  @override
  Future<void> updateProduct(Product product) async {
    await _db
        .collection(Config.productsCollection)
        .doc(product.id)
        .update(product.toMap());
  }

  // 5. Implement deleteProduct
  @override
  Future<void> deleteProduct(String id) async {
    await _db.collection(Config.productsCollection).doc(id).delete();
  }

  // 6. Implement streamLowStockProducts
  @override
  Stream<List<Product>> streamLowStockProducts(String ownerId) {
    // Implement logic to filter products where quantity < stockAlertLevel
    return _db
        .collection(Config.productsCollection)
        .where('ownerId', isEqualTo: ownerId)
        // ⚠️ NOTE: Firestore does not support range queries on multiple fields
        // or OR queries easily. You may need to filter client-side 
        // OR add a specific 'isLowStock' field to the database.
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Product.fromMap(d.id, d.data()))
            .where((product) => (product.quantityInStock) < (product.stockAlertLevel))
            .toList());
  }

  // 7. Implement updateProductStock
  @override
  Future<void> updateProductStock(String id, int newQuantity) async {
    await _db.collection(Config.productsCollection).doc(id).update({
      'quantity': newQuantity,
      // You might also want to update the last updated timestamp here
    });
  }
}