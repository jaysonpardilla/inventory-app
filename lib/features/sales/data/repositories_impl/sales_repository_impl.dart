// lib/features/sales/data/repositories_impl/sales_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/repositories/sales_repository.dart';
import '../../domain/entities/daily_sales.dart';
import '../../domain/entities/weekly_sales.dart';
import '../../domain/entities/monthly_sales.dart';
import '../../domain/entities/total_sales.dart';
import '../datasources/sales_datasource.dart';
// Note: You may need to import SaleItem if it's not defined in the repository file
import '../../domain/usecases/execute_sale_usecase.dart'; 

class SalesRepositoryImpl implements SalesRepository {
  final SalesDataSource dataSource;

  SalesRepositoryImpl(this.dataSource);

  // 💡 MISSING METHOD IMPLEMENTATION (Fixed)
  @override
  Future<Either<Failure, void>> executeSaleTransaction(
      List<SaleItem> items, String ownerId) async {
    try {
      // Delegate the complex, atomic, multi-database operation to the Data Source
      await dataSource.executeSaleTransaction(items, ownerId);
      return const Right(null);
    } catch (e) {
      // Catch any exceptions during the transaction and map to a ServerFailure
      return Left(ServerFailure(message: 'Sale transaction failed: ${e.toString()}'));
    }
  }

  @override
  Stream<List<DailySales>> streamDailySales(String ownerId) =>
      dataSource.streamDailySales(ownerId);

  @override
  Stream<List<WeeklySales>> streamWeeklySales(String ownerId) =>
      dataSource.streamWeeklySales(ownerId);

  @override
  Stream<List<MonthlySales>> streamMonthlySales(String ownerId) =>
      dataSource.streamMonthlySales(ownerId);

  @override
  Stream<List<TotalSales>> streamTotalSales(String ownerId) =>
      dataSource.streamTotalSales(ownerId);
}