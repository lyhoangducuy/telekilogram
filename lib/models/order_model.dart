enum OrderStatus { unpaid, shipping, done, cancelled }

class OrderItem {
  final int productId;
  final String title;
  final int price; // ✅ int
  final int qty;
  final String thumbnail;

  OrderItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.qty,
    required this.thumbnail,
  });

  int get lineTotal => price * qty;
}

class Order {
  final String id;
  final DateTime createdAt;

  // ✅ cho phép chỉnh khi unpaid
  String customerName;
  String phone;
  String address;
  String note;

  final List<OrderItem> items;
  OrderStatus status;

  // ✅ Payment info
  bool paid;
  String paymentMethod; // unpaid / paypal
  DateTime? paidAt;

  Order({
    required this.id,
    required this.createdAt,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.note,
    required this.items,
    required this.status,
    this.paid = false,
    this.paymentMethod = "unpaid",
    this.paidAt,
  });

  int get totalQty => items.fold(0, (s, e) => s + e.qty);
  int get total => items.fold(0, (s, e) => s + e.lineTotal);
}
