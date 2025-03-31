import 'package:finish_crud_week8/data/firebase_repository/iphone_stock_remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/providers/async_value.dart';
import 'ui/providers/iphone_stock_provider.dart';
// import 'data/mock_repository/iphone_stock_mock_repository.dart';

void main() {
  // Run the app
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
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

class StockListScreen extends StatelessWidget {
  const StockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access provider data
    final provider = context.watch<IphoneStockProvider>();
    final iphoneStock = provider.iphoneStock;
    final iphoneStockAsyncValue = provider.iphoneStockAsyncValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text("iPhone Stock"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddItemDialog(context);
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (iphoneStockAsyncValue.state == AsyncValueState.loading) {
            return const Center(child: CircularProgressIndicator());
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    // Show a dialog for adding a new item
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Model Name"),
                // Add TextEditingController to manage input
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                // Add TextEditingController to manage input
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
                // Add TextEditingController to manage input
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Handle the addition logic, update provider
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}