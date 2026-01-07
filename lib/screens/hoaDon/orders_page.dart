import 'package:flutter/material.dart';
import 'package:telekilogram/controller/hoaDon/orders_controller.dart';
import 'package:telekilogram/models/order_model.dart';
import 'package:telekilogram/screens/hoaDon/order_detail_page.dart';
import 'package:telekilogram/payments/paypal_helper.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  String _stText(OrderStatus st) {
    switch (st) {
      case OrderStatus.unpaid:
        return "Chưa thanh toán";
      case OrderStatus.shipping:
        return "Đang giao";
      case OrderStatus.done:
        return "Thành công";
      case OrderStatus.cancelled:
        return "Đã hủy";
    }
  }

  Widget _statusChip(OrderStatus st) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _stText(st),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  void _openDetail(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: id)),
    );
  }

  Future<void> _payPaypal(BuildContext context, Order o) async {
    // chỉ cho unpaid
    if (o.status != OrderStatus.unpaid) return;

    await PayPalHelper.pay(
      context: context,
      amount: o.total.toDouble(),
      onPaid: () {
        orders.markPaidPaypal(o.id); // ✅ đúng hàm
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PayPal ✅ Đơn chuyển sang Đang giao")),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: orders,
      builder: (_, __) {
        final unpaid = orders.byStatus(OrderStatus.unpaid);
        final shipping = orders.byStatus(OrderStatus.shipping);
        final done = orders.byStatus(OrderStatus.done);
        final cancelled = orders.byStatus(OrderStatus.cancelled);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Đơn hàng / Lịch sử mua"),
            bottom: TabBar(
              controller: _tab,
              tabs: [
                Tab(text: "Chưa TT (${unpaid.length})"),
                Tab(text: "Đang giao (${shipping.length})"),
                Tab(text: "Thành công (${done.length})"),
                Tab(text: "Đã hủy (${cancelled.length})"),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tab,
            children: [
              _list(context, unpaid),
              _list(context, shipping),
              _list(context, done),
              _list(context, cancelled),
            ],
          ),
        );
      },
    );
  }

  Widget _list(BuildContext context, List<Order> data) {
    if (data.isEmpty) {
      return const Center(child: Text("Chưa có đơn nào."));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final o = data[i];
        final isUnpaid = o.status == OrderStatus.unpaid;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openDetail(context, o.id),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Icon(Icons.receipt_long),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Mã #${o.id}",
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    _statusChip(o.status),
                  ],
                ),

                const SizedBox(height: 6),

                Text("SL: ${o.totalQty} • Tổng: \$${o.total}"),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Text(
                      "Chạm để xem chi tiết ➜",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      o.createdAt.toLocal().toString(),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),

                // Actions
                if (isUnpaid) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            orders.cancel(o.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Đã hủy đơn ✅")),
                            );
                          },
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text("Hủy"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _payPaypal(context, o),
                          icon: const Icon(Icons.account_balance_wallet),
                          label: const Text("PayPal"),
                        ),
                      ),
                    ],
                  ),
                ] else if (o.status == OrderStatus.shipping) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        orders.markDone(o.id); // ✅ demo shipping -> done
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Đã chuyển sang Thành công ✅")),
                        );
                      },
                      icon: const Icon(Icons.local_shipping_outlined),
                      label: const Text("Demo: Xác nhận đã giao"),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
