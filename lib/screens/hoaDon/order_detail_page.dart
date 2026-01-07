import 'package:flutter/material.dart';
import 'package:telekilogram/controller/hoaDon/orders_controller.dart';
import 'package:telekilogram/models/order_model.dart';
import 'package:telekilogram/payments/paypal_helper.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addrCtrl;
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    final o = orders.byId(widget.orderId);

    _nameCtrl = TextEditingController(text: o?.customerName ?? "");
    _phoneCtrl = TextEditingController(text: o?.phone ?? "");
    _addrCtrl = TextEditingController(text: o?.address ?? "");
    _noteCtrl = TextEditingController(text: o?.note ?? "");
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addrCtrl.dispose();
    _noteCtrl.dispose();
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: orders,
      builder: (_, __) {
        final o = orders.byId(widget.orderId);
        if (o == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Chi tiết đơn")),
            body: const Center(child: Text("Đơn không tồn tại / đã bị xoá")),
          );
        }

        final editable = o.status == OrderStatus.unpaid;

        void save() {
          if (!editable) return;
          if (!_formKey.currentState!.validate()) return;

          orders.updateInfo(
            id: o.id,
            customerName: _nameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            address: _addrCtrl.text.trim(),
            note: _noteCtrl.text.trim(),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đã cập nhật đơn ✅")),
          );
        }

        void cancel() {
          if (!editable) return;
          orders.cancel(o.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đã hủy đơn ✅")),
          );
          setState(() {});
        }

        Future<void> payPaypal() async {
          if (!editable) return;

          await PayPalHelper.pay(
            context: context,
            amount: o.total.toDouble(),
            onPaid: () {
              orders.markPaidPaypal(o.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("PayPal ✅ Đơn chuyển sang Đang giao")),
              );
              setState(() {});
            },
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Đơn #${o.id}"),
            actions: [
              // demo: shipping -> done
              if (o.status == OrderStatus.shipping)
                IconButton(
                  tooltip: "Demo: Xác nhận đã giao",
                  onPressed: () {
                    orders.markDone(o.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Đã chuyển sang Thành công ✅")),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.check_circle_outline),
                ),

              // xóa (tùy chọn) chỉ khi unpaid/cancelled
              if (o.status == OrderStatus.unpaid || o.status == OrderStatus.cancelled)
                IconButton(
                  tooltip: "Xóa đơn",
                  onPressed: () {
                    orders.delete(o.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Đã xóa đơn ✅")),
                    );
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long, size: 26),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Trạng thái: ${_stText(o.status)}\nSL: ${o.totalQty}\nTổng: \$${o.total}",
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    Text(
                      o.createdAt.toLocal().toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              if (o.paid)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.withOpacity(0.25)),
                  ),
                  child: Text(
                    "Đã thanh toán: ${o.paymentMethod.toUpperCase()} • ${o.paidAt?.toLocal().toString() ?? ""}",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.withOpacity(0.25)),
                  ),
                  child: const Text(
                    "Chưa thanh toán",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),

              const SizedBox(height: 16),

              // Customer form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      enabled: editable,
                      decoration: const InputDecoration(
                        labelText: "Tên khách",
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? "Nhập tên khách" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneCtrl,
                      enabled: editable,
                      decoration: const InputDecoration(
                        labelText: "SĐT",
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? "Nhập SĐT" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _addrCtrl,
                      enabled: editable,
                      decoration: const InputDecoration(
                        labelText: "Địa chỉ",
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? "Nhập địa chỉ" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _noteCtrl,
                      enabled: editable,
                      decoration: const InputDecoration(
                        labelText: "Ghi chú",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (editable) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton.icon(
                          onPressed: save,
                          icon: const Icon(Icons.save),
                          label: const Text("Lưu chỉnh sửa"),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: cancel,
                              icon: const Icon(Icons.cancel_outlined),
                              label: const Text("Hủy đơn"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: payPaypal,
                              icon: const Icon(Icons.account_balance_wallet),
                              label: const Text("PayPal"),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Đơn đã qua trạng thái Chưa thanh toán nên KHÔNG thể chỉnh sửa / hủy / thanh toán lại.",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 18),
              const Text("Sản phẩm", style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),

              ...o.items.map(
                (it) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          it.thumbnail,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.black12,
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              it.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${it.price} x ${it.qty} = \$${it.lineTotal}",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
