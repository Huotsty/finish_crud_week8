
import '../../models/iphone_stock.dart';

abstract class IPhoneStockRepository {
  Future<List<IphoneStock>> getIPhoneStock();
  
}