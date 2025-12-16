import 'package:telekilogram/models/product.dart';

class CartStore {
  static final List<Product> _items = [];

  static List<Product> get items => _items;

  static void add(Product product) {
    _items.add(product);
  }

  static void remove(Product product) {
    _items.remove(product);
  }

  static void clear() {
    _items.clear();
  }

  /// ✅ TỔNG TIỀN
  static double get totalPrice {
    return _items.fold(
      0,
      (sum, item) => sum + item.price,
    );
  }
}
