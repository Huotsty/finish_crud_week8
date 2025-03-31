import 'package:finish_crud_week8/data/mock_repository/iphone_stock_mock_repository.dart';
import 'package:finish_crud_week8/ui/providers/iphone_stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/providers/async_value.dart';

void main() {
  // Run the app
  runApp(
    ChangeNotifierProvider(
      create:
          (context) =>
              IphoneStockProvider(repository: IphoneStockMockRepository()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: StockListScreen()),
    );
  }
}

class StockListScreen extends StatelessWidget {
  const StockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access provider data
    final provider = context.watch<IphoneStockProvider>();
    final iphoneStock = provider.iphoneStock;
    final iphoneStockAsyncValue = provider.iphoneStockAsyncValue;
    if (iphoneStockAsyncValue.state == AsyncValueState.loading) {
      return Center(child: CircularProgressIndicator());
    } else if (iphoneStockAsyncValue.state == AsyncValueState.error) {
      return Center(child: Text(iphoneStockAsyncValue.error.toString()));
    } else {
      return ListView.builder(
        itemCount: iphoneStock.length,
        itemBuilder: (context, index) {
          final stock = iphoneStock[index];
          return ListTile(
            title: Text(stock.iphoneModel),
            subtitle: Text('Price: \$${stock.price}'),
            trailing: Text('Stock: ${stock.quantity}'),
          );
        },
      );
    }
  }
}
