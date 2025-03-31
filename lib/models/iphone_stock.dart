class IphoneStock{
  final String id;
  final String iphoneModel;
  final double price;
  final int quantity;
  IphoneStock({required this.id, required this.iphoneModel, required this.price, required this.quantity});
  @override
  bool operator ==(Object other) {
    return other is IphoneStock && other.id == id;
  }
  @override
  int get hashCode => id.hashCode;
  @override
  String toString() {
    return 'IphoneStock{id: $id, iphoneModel: $iphoneModel, price: $price, quantity: $quantity}';
  }
}

class IphoneStockDto {
  static IphoneStock fromJson(String id, Map<String, dynamic> json) {
    return IphoneStock(
      id: id,
      iphoneModel: json['iphoneModel'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }

  static Map<String, dynamic> toJson(IphoneStock iphoneStock) {
    return {
      'iphoneModel': iphoneStock.iphoneModel,
      'price': iphoneStock.price,
      'quantity': iphoneStock.quantity,
    };
  }
}