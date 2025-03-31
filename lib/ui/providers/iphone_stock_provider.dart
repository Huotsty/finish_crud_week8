import 'package:finish_crud_week8/data/repositories/iphone_stock_repository.dart';
import 'package:flutter/material.dart';

import '../../models/iphone_stock.dart';
import 'async_value.dart';

class IphoneStockProvider extends ChangeNotifier {
  List<IphoneStock> _iphoneStock = [];
  late AsyncValue<List<IphoneStock>> iphoneStockAsyncValue;
  final IPhoneStockRepository repository;

  IphoneStockProvider({required this.repository}) {
    fetchIphoneStock();
  }
  List<IphoneStock> get iphoneStock => _iphoneStock;
  Future<void> fetchIphoneStock() async {
    iphoneStockAsyncValue = AsyncValue.loading();
    notifyListeners();
    try {
      _iphoneStock = await repository.getIPhoneStock();
      _iphoneStock = _iphoneStock.toList();
      // 3  Handle success
      iphoneStockAsyncValue = AsyncValue.success(_iphoneStock);
    } catch (e) {
      iphoneStockAsyncValue = AsyncValue.error(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
