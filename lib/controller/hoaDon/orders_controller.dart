import 'package:flutter/material.dart';
import 'package:telekilogram/models/order_model.dart';

class OrdersController extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get all => List.unmodifiable(_orders);

  Order? byId(String id) {
    try {
      return _orders.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Order> byStatus(OrderStatus st) {
    final list = _orders.where((e) => e.status == st).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  void add(Order o) {
    _orders.insert(0, o);
    notifyListeners();
  }

  // ✅ chỉ sửa khi unpaid
  void updateInfo({
    required String id,
    required String customerName,
    required String phone,
    required String address,
    required String note,
  }) {
    final o = byId(id);
    if (o == null) return;
    if (o.status != OrderStatus.unpaid) return;

    o.customerName = customerName;
    o.phone = phone;
    o.address = address;
    o.note = note;
    notifyListeners();
  }

  // ✅ hủy chỉ khi unpaid
  void cancel(String id) {
    final o = byId(id);
    if (o == null) return;
    if (o.status != OrderStatus.unpaid) return;

    o.status = OrderStatus.cancelled;
    notifyListeners();
  }

  // ✅ thanh toán PayPal success: unpaid -> shipping
  void markPaidPaypal(String id) {
    final o = byId(id);
    if (o == null) return;
    if (o.status != OrderStatus.unpaid) return;

    o.paid = true;
    o.paymentMethod = "paypal";
    o.paidAt = DateTime.now();
    o.status = OrderStatus.shipping;

    notifyListeners();
  }

  // ✅ demo: shipping -> done
  void markDone(String id) {
    final o = byId(id);
    if (o == null) return;
    if (o.status != OrderStatus.shipping) return;

    o.status = OrderStatus.done;
    notifyListeners();
  }

  // (tuỳ chọn) xóa: chỉ khi unpaid/cancelled
  void delete(String id) {
    final o = byId(id);
    if (o == null) return;
    if (o.status == OrderStatus.shipping || o.status == OrderStatus.done) return;

    _orders.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}

final orders = OrdersController();
