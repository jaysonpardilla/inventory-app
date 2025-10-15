// lib/features/stock_alert/data/datasources/stock_alert_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
// Updated import to the new Product Entity location
import '../../../products/domain/entities/product.dart'; 

class StockAlertDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Renamed the method to be more explicit about its data sourcing role
  Stream<List<Product>> streamAllProductsForAlert(String userId) {
    return _db
        .collection('products')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      // Note: The filtering logic (p.quantityInStock < 10) is typically moved to a Usecase in Clean Architecture, 
      // but for direct migration, we keep it here for now.
      return snapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .where((p) => p.quantityInStock < 10) 
          .toList();
    });
  }
}