import 'package:finish_crud_week8/models/iphone_stock.dart';
import 'package:finish_crud_week8/ui/providers/async_value.dart';
import 'package:finish_crud_week8/ui/providers/iphone_stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockListScreen extends StatelessWidget {
  const StockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IphoneStockProvider>();
    final iphoneStock = provider.iphoneStock;
    final iphoneStockAsyncValue = provider.iphoneStockAsyncValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "iPhone Stock",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {
        //       _showAddItemDialog(context);
        //     },
        //   ),
        // ],
      ),
      body: Builder(
        builder: (context) {
          if (iphoneStockAsyncValue.state == AsyncValueState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (iphoneStockAsyncValue.state == AsyncValueState.error) {
            return Center(
              child: Text(
                "Error: ${iphoneStockAsyncValue.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: iphoneStock.length,
              itemBuilder: (context, index) {
                final stock = iphoneStock[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: const Icon(
                        Icons.phone_iphone,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      stock.iphoneModel,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Price: \$${stock.price}\nQuantity: ${stock.quantity}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: () {
                            _showEditItemDialog(context, stock);
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  content: const Text(
                                    "Are you sure you want to delete this item?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              try {
                                await provider.deleteIphoneStock(stock.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Item deleted successfully!"),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e")),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
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
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, IphoneStock stock) {
    final modelController = TextEditingController(text: stock.iphoneModel);
    final priceController = TextEditingController(text: stock.price.toString());
    final quantityController = TextEditingController(
      text: stock.quantity.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: modelController,
                decoration: const InputDecoration(labelText: "Model Name"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
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
              onPressed: () async {
                final model = modelController.text.trim();
                final priceText = priceController.text.trim();
                final quantityText = quantityController.text.trim();

                if (model.isEmpty ||
                    priceText.isEmpty ||
                    quantityText.isEmpty ||
                    double.tryParse(priceText) == null ||
                    int.tryParse(quantityText) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter valid data")),
                  );
                  return;
                }

                // Create updated iPhoneStock object
                final updatedStock = IphoneStock(
                  id: stock.id, // Retain the existing ID
                  iphoneModel: model,
                  price: double.parse(priceText),
                  quantity: int.parse(quantityText),
                );

                // Update via provider
                final provider = Provider.of<IphoneStockProvider>(
                  context,
                  listen: false,
                );

                try {
                  await provider.updateIphoneStock(updatedStock);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Item updated successfully!")),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final modelController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: modelController,
                decoration: const InputDecoration(labelText: "Model Name"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
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
              onPressed: () async {
                final model = modelController.text.trim();
                final priceText = priceController.text.trim();
                final quantityText = quantityController.text.trim();

                if (model.isEmpty ||
                    priceText.isEmpty ||
                    quantityText.isEmpty ||
                    double.tryParse(priceText) == null ||
                    int.tryParse(quantityText) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter valid data")),
                  );
                  return;
                }

                final newIphoneStock = IphoneStock(
                  id: '',
                  iphoneModel: model,
                  price: double.parse(priceText),
                  quantity: int.parse(quantityText),
                );

                final provider = Provider.of<IphoneStockProvider>(
                  context,
                  listen: false,
                );

                try {
                  await provider.addIphoneStock(newIphoneStock);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Item added successfully!")),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
