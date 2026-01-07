import 'package:flutter/foundation.dart';
import 'package:telekilogram/models/product.dart';

class CartItem {
  final Product product;
  int qty;

  CartItem({required this.product, required this.qty});

  num get lineTotal => product.price * qty;
}

class CartController extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalQty => _items.values.fold(0, (s, e) => s + e.qty);

  num get totalPrice => _items.values.fold<num>(0, (s, e) => s + e.lineTotal);

  void add(Product p, {int qty = 1}) {
    final existing = _items[p.id];
    if (existing != null) {
      existing.qty += qty;
    } else {
      _items[p.id] = CartItem(product: p, qty: qty);
    }
    notifyListeners();
  }

  void increase(int productId) {
    final it = _items[productId];
    if (it == null) return;
    it.qty += 1;
    notifyListeners();
  }

  void decrease(int productId) {
    final it = _items[productId];
    if (it == null) return;
    it.qty -= 1;
    if (it.qty <= 0) _items.remove(productId);
    notifyListeners();
  }

  void remove(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// dùng chung toàn app
final cart = CartController();
