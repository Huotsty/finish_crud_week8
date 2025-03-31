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
  Future<void> addIphoneStock(IphoneStock iphoneStock) async {
    try {
      await repository.addIPhoneStock(iphoneStock);
      _iphoneStock.add(iphoneStock);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Error adding iPhone stock: $e");
    }
  }
  Future<void> deleteIphoneStock(String id) async {
    try {
      await repository.deleteIPhoneStock(id);
      _iphoneStock.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Error deleting iPhone stock: $e");
    }
  }
  Future<void> updateIphoneStock(IphoneStock iphoneStock) async {
  try {
    // Update item in Firebase
    await repository.updateIPhoneStock(iphoneStock);

    // Update item in local list
    final index = _iphoneStock.indexWhere((item) => item.id == iphoneStock.id);
    if (index != -1) {
      _iphoneStock[index] = iphoneStock; // Replace with updated item
      notifyListeners(); // Notify listeners to update UI
    }
  } catch (e) {
    print("Error updating iPhone stock: $e");
  }
}
}
