
import '../../models/iphone_stock.dart';

abstract class IPhoneStockRepository {
  Future<List<IphoneStock>> getIPhoneStock();
  Future<void> addIPhoneStock(IphoneStock iphoneStock);
  Future<void> deleteIPhoneStock(String id);
}