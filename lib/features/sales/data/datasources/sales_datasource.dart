//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_app/features/sales/domain/usecases/execute_sale_usecase.dart';
//import '../../../../core/config.dart';
import '../../domain/entities/daily_sales.dart';
import '../../domain/entities/weekly_sales.dart';
import '../../domain/entities/monthly_sales.dart';
import '../../domain/entities/total_sales.dart';

abstract class SalesDataSource {

// 🔹 Daily Sales Stream (No body, forcing implementation in concrete class)
 Stream<List<DailySales>> streamDailySales(String ownerId);
 
 // 🔹 Weekly Sales Stream
 Stream<List<WeeklySales>> streamWeeklySales(String ownerId);
 // 🔹 Monthly Sales Stream
 Stream<List<MonthlySales>> streamMonthlySales(String ownerId);

// 🔹 Total Sales Stream
 Stream<List<TotalSales>> streamTotalSales(String ownerId);

Future<void> executeSaleTransaction(List<SaleItem> items, String ownerId);
}