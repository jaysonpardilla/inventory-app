// lib/features/stock_alert/data/repositories_impl/stock_alert_repository_impl.dart
import '../../domain/repositories/stock_alert_repository.dart';
import '../../../products/domain/entities/product.dart'; // We stream Products that are low stock
import '../datasources/stock_alert_datasource.dart';

class StockAlertRepositoryImpl implements StockAlertRepository {
  final StockAlertDataSource dataSource;

  StockAlertRepositoryImpl(this.dataSource);

  @override
  Stream<List<Product>> streamLowStockProducts(String ownerId) {
    // The filtering logic for 'low stock' is applied in the data source, 
    // but the final filtering/business rule check could also be added here 
    // or in the Usecase for stricter clean architecture. For now, pass through.
    return dataSource.streamAllProductsForAlert(ownerId);
  }
}