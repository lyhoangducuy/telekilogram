import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:telekilogram/auth/api_auth.dart';
import 'package:telekilogram/auth/auth_storage.dart';
import 'package:telekilogram/auth/auth_bootstrap_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _loading = true;
  Map<String, dynamic>? _me;

  @override
  void initState() {
    super.initState();
    _loadMe();
  }

  Future<void> _loadMe() async {
    try {
      final user = await apiAuth.meWithAutoRefresh();
      if (!mounted) return;
      setState(() {
        _me = user;
        _loading = false;
      });
    } catch (_) {
      await AuthStorage.clear();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthBootstrapPage()),
        (_) => false,
      );
    }
  }

  String _txt(String key, {String fallback = "-"}) {
    final v = (_me?[key] ?? "").toString().trim();
    return v.isEmpty ? fallback : v;
  }

  String get _fullName {
    final fn = _txt("firstName", fallback: "");
    final ln = _txt("lastName", fallback: "");
    final name = "$fn $ln".trim();
    return name.isEmpty ? "User" : name;
  }

  String get _avatarUrl {
    final img = _txt("image", fallback: "");
    return img.isEmpty ? "https://picsum.photos/300" : img;
  }

  String get _addressText {
    final addr = _me?["address"];
    if (addr is Map) {
      final a = (addr["address"] ?? "").toString().trim();
      final city = (addr["city"] ?? "").toString().trim();
      final full = [a, city].where((x) => x.isNotEmpty).join(", ");
      return full.isEmpty ? "Chưa có" : full;
    }
    return "Chưa có";
  }

  Future<void> _openEdit() async {
    if (_me == null) return;

    final phoneCtrl = TextEditingController(text: _txt("phone", fallback: ""));
    final addrCtrl = TextEditingController(
      text: (_me?["address"] is Map) ? ((_me?["address"]["address"] ?? "").toString()) : "",
    );
    final cityCtrl = TextEditingController(
      text: (_me?["address"] is Map) ? ((_me?["address"]["city"] ?? "").toString()) : "",
    );

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        final formKey = GlobalKey<FormState>();
        bool saving = false;

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Chỉnh sửa hồ sơ",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(
                        labelText: "SĐT",
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? "Nhập SĐT" : null,
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: addrCtrl,
                      decoration: const InputDecoration(
                        labelText: "Địa chỉ (đường/số nhà)",
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? "Nhập địa chỉ" : null,
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: cityCtrl,
                      decoration: const InputDecoration(
                        labelText: "Thành phố",
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? "Nhập thành phố" : null,
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: saving
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;

                                setSheetState(() => saving = true);
                                try {
                                  final access = await AuthStorage.accessToken();
                                  final refresh = await AuthStorage.refreshToken();

                                  if (access == null || access.isEmpty) {
                                    throw Exception("Mất token. Vui lòng đăng nhập lại.");
                                  }

                                  final id = (_me?["id"] ?? 0) as int;

                                  final updated = await apiAuth.updateUser(
                                    id: id,
                                    accessToken: access,
                                    phone: phoneCtrl.text.trim(),
                                    address: {
                                      "address": addrCtrl.text.trim(),
                                      "city": cityCtrl.text.trim(),
                                    },
                                  );

                                  if (!mounted) return;

                                  setState(() => _me = updated);

                                  await AuthStorage.saveSession(
                                    accessToken: access,
                                    refreshToken: refresh ?? "",
                                    userJson: jsonEncode(updated),
                                  );

                                  Navigator.pop(ctx, true);
                                } catch (e) {
                                  Navigator.pop(ctx, false);
                                  ScaffoldMessenger.of(this.context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Lỗi ❌ ${e.toString().replaceFirst("Exception: ", "")}",
                                      ),
                                    ),
                                  );
                                } finally {
                                  setSheetState(() => saving = false);
                                }
                              },
                        child: saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text("Lưu"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    phoneCtrl.dispose();
    addrCtrl.dispose();
    cityCtrl.dispose();

    if (ok == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã cập nhật hồ sơ ✅")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Hồ sơ của tôi")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hồ sơ của tôi"),
        actions: [
          IconButton(
            onPressed: _openEdit,
            icon: const Icon(Icons.edit),
            tooltip: "Chỉnh sửa",
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    _avatarUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 72,
                      height: 72,
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
                        _fullName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(_txt("email", fallback: "—"), style: const TextStyle(color: Colors.black54)),
                      const SizedBox(height: 6),
                      Text("@${_txt("username", fallback: "—")}", style: const TextStyle(color: Colors.blueGrey)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          const Text("Thông tin hồ sơ", style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),

          _infoTile(Icons.badge, "ID", _txt("id")),
          _infoTile(Icons.phone, "SĐT", _txt("phone", fallback: "Chưa có")),
          _infoTile(Icons.home, "Địa chỉ", _addressText),

          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _openEdit,
              icon: const Icon(Icons.edit),
              label: const Text("Chỉnh sửa hồ sơ"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          Expanded(
            child: Text(
              value.trim().isEmpty ? "—" : value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
