import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_app/features/sales/domain/entities/daily_sales.dart';
import 'package:inventory_app/features/sales/domain/entities/weekly_sales.dart';
import 'package:uuid/uuid.dart';

//import '../../../products/domain/entities/product.dart';
import '../../domain/entities/monthly_sales.dart';
import '../../domain/entities/total_sales.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/usecases/execute_sale_usecase.dart'; // For SaleItem
import '../datasources/sales_datasource.dart';

class SalesDataSourceImpl implements SalesDataSource {
  final FirebaseFirestore _db;
  final Uuid _uuid = const Uuid();

  SalesDataSourceImpl(this._db);

  // 💡 CRITICAL: Atomic Batch Write for Sale Execution
  @override
  Future<void> executeSaleTransaction(
      List<SaleItem> items, String ownerId) async {
    final now = DateTime.now();
    final batch = _db.batch();
    
    // Date keys for aggregate documents
    final dailyDocId = '${now.year}-${now.month}-${now.day}';
    final monthlyDocId = '${now.year}-${now.month}';
    
    // References to collections
    final productCol = _db.collection('products');
    final transactionCol = _db.collection('transactions');
    final dailySalesCol = _db.collection('dailySales');
    final monthlySalesCol = _db.collection('monthlySales');

    double totalSaleAmount = 0.0;

    for (var item in items) {
      final product = item.product;
      final qtySold = item.quantity;
      final salePrice = product.price;
      final itemTotal = salePrice * qtySold;

      totalSaleAmount += itemTotal;

      // 1. Update Product Stock (Decrease quantity)
      final productRef = productCol.doc(product.id);
      batch.update(productRef, {
        'quantityInStock': FieldValue.increment(-qtySold),
      });

      // 2. Create InventoryTransaction Record
      final transactionRef = transactionCol.doc(_uuid.v4());
      final transaction = InventoryTransaction(
        id: transactionRef.id,
        productId: product.id,
        transactionType: 'SALE',
        transactionDate: now,
        amount: itemTotal,
        quantity: qtySold,
        ownerId: ownerId,
      );
      batch.set(transactionRef, transaction.toMap());
    }
    
    // 3. Update Sales Aggregates (Atomic Increments)

    // Update Daily Sales
    batch.set(dailySalesCol.doc(dailyDocId), {
      'salesAmount': FieldValue.increment(totalSaleAmount),
      'date': now,
      'ownerId': ownerId,
    }, SetOptions(merge: true));
    
    // Update Monthly Sales
    batch.set(monthlySalesCol.doc(monthlyDocId), {
      'salesAmount': FieldValue.increment(totalSaleAmount),
      'year': now.year,
      'month': now.month,
      'ownerId': ownerId,
    }, SetOptions(merge: true));

    // Commit all operations atomically
    await batch.commit();
  }

  // --- Streams for Dashboard Metrics ---

  @override
  Stream<List<DailySales>> streamDailySales(String ownerId) {
    return _db
        .collection('dailySales')
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => DailySales.fromMap(d.id, d.data())).toList());
  }

  @override
  Stream<List<MonthlySales>> streamMonthlySales(String ownerId) {
    return _db
        .collection('monthlySales')
        .where('ownerId', isEqualTo: ownerId)
        // Orders by year then month to get historical trend
        .orderBy('year', descending: false)
        .orderBy('month', descending: false) 
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => MonthlySales.fromMap(d.id, d.data())).toList());
  }

  // 💡 FIX 2: Correct streamWeeklySales return type and mapping
  @override
  Stream<List<WeeklySales>> streamWeeklySales(String ownerId) {
    return _db
        .collection('weeklySales') 
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) => 
            snap.docs.map((d) => WeeklySales.fromMap(d.id, d.data())).toList()); 
  }
  
  // 💡 FIX 3: Correct streamTotalSales return type and mapping
  @override
  Stream<List<TotalSales>> streamTotalSales(String ownerId) {
    // TotalSales is often a single document per owner (or product aggregate)
    return _db
        .collection('totalSales')
        .doc(ownerId) // Assuming one document per owner ID
        .snapshots()
        .map((snap) => snap.data() != null 
            ? [TotalSales.fromMap(snap.id, snap.data()!)] 
            : []);
  }
}