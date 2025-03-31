import 'package:finish_crud_week8/data/repositories/iphone_stock_repository.dart';
import 'package:finish_crud_week8/models/iphone_stock.dart';

class IphoneStockMockRepository extends IPhoneStockRepository{

  final List<IphoneStock> _iphoneStock = [
    IphoneStock(id: '1', iphoneModel: 'iPhone 14', price: 999.99, quantity: 10),
    IphoneStock(id: '2', iphoneModel: 'iPhone 14 Pro', price: 1099.99, quantity: 5),
    IphoneStock(id: '3', iphoneModel: 'iPhone 14 Pro Max', price: 1199.99, quantity: 2),
    IphoneStock(id: '4', iphoneModel: 'iPhone SE', price: 499.99, quantity: 20),
    IphoneStock(id: '5', iphoneModel: 'iPhone 13', price: 799.99, quantity: 15),
    IphoneStock(id: '6', iphoneModel: 'iPhone 13 Mini', price: 699.99, quantity: 8),
    IphoneStock(id: '7', iphoneModel: 'iPhone 12', price: 599.99, quantity: 12),
    IphoneStock(id: '8', iphoneModel: 'iPhone 12 Mini', price: 499.99, quantity: 18),
    IphoneStock(id: '9', iphoneModel: 'iPhone XR', price: 399.99, quantity: 25),
    IphoneStock(id: '10', iphoneModel: 'iPhone XS', price: 699.99, quantity: 7),
  ];
  @override
  Future<List<IphoneStock>> getIPhoneStock() {
    return Future.delayed(const Duration(seconds: 2), () {
      return _iphoneStock;
    });
  }

}