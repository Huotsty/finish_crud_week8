import 'package:finish_crud_week8/data/firebase_repository/iphone_stock_remote_repository.dart';
import 'package:finish_crud_week8/ui/stock_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/providers/iphone_stock_provider.dart';
// import 'data/mock_repository/iphone_stock_mock_repository.dart';

void main() {
  // Run the app
  runApp(
    ChangeNotifierProvider(
      create:
          (context) =>
              IphoneStockProvider(repository: IphoneStockRemoteRepository()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StockListScreen(),
    );
  }
}
