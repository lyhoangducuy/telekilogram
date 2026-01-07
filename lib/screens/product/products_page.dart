import 'dart:async';
import 'package:flutter/material.dart';
import 'package:telekilogram/api/api.dart';
import 'package:telekilogram/controller/cart/cart_controller.dart';
import 'package:telekilogram/models/product.dart';
import 'package:telekilogram/screens/product/product_detail_page.dart';

enum PriceSort { none, lowToHigh, highToLow }

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  bool _loading = false;
  String _q = '';

  List<Product> _products = [];

  // ✅ filter/sort UI state
  String _selectedCategory = "Tất cả";
  PriceSort _priceSort = PriceSort.none;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final data = _q.trim().isEmpty
          ? await testApi.getAllProducts(limit: 30, skip: 0)
          : await testApi.searchProducts(_q.trim(), limit: 30, skip: 0);

      if (!mounted) return;
      setState(() {
        _products = data;

        // nếu category đang chọn không còn trong list, reset về Tất cả
        final cats = _categoriesFrom(_products);
        if (_selectedCategory != "Tất cả" && !cats.contains(_selectedCategory)) {
          _selectedCategory = "Tất cả";
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi ❌ ${e.toString().replaceFirst('Exception: ', '')}")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearchChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() => _q = v);
      _fetch();
    });
  }

  List<String> _categoriesFrom(List<Product> list) {
    final set = <String>{};
    for (final p in list) {
      if (p.category.trim().isNotEmpty) set.add(p.category);
    }
    final cats = set.toList()..sort();
    return cats;
  }

  List<Product> get _filteredProducts {
    List<Product> list = List<Product>.from(_products);

    // filter category
    if (_selectedCategory != "Tất cả") {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }

    // sort price
    if (_priceSort == PriceSort.lowToHigh) {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_priceSort == PriceSort.highToLow) {
      list.sort((a, b) => b.price.compareTo(a.price));
    }

    return list;
  }

  String _sortLabel(PriceSort s) {
    switch (s) {
      case PriceSort.none:
        return "Không sắp xếp";
      case PriceSort.lowToHigh:
        return "Giá thấp → cao";
      case PriceSort.highToLow:
        return "Giá cao → thấp";
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ["Tất cả", ..._categoriesFrom(_products)];
    final list = _filteredProducts;

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchCtrl,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: "Tìm sản phẩm (iphone, laptop...)",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchCtrl.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchCtrl.clear();
                        _onSearchChanged('');
                        setState(() {});
                      },
                    ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),

        // ✅ FILTER BAR (category + sort)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Category dropdown
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _selectedCategory = v);
                  },
                  decoration: InputDecoration(
                    labelText: "Danh mục",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Sort dropdown
              Expanded(
                child: DropdownButtonFormField<PriceSort>(
                  value: _priceSort,
                  items: PriceSort.values
                      .map((s) => DropdownMenuItem(value: s, child: Text(_sortLabel(s), overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _priceSort = v);
                  },
                  decoration: InputDecoration(
                    labelText: "Sắp xếp",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Info row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text("Hiển thị: ${list.length}"),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedCategory = "Tất cả";
                    _priceSort = PriceSort.none;
                  });
                },
                icon: const Icon(Icons.filter_alt_off),
                label: const Text("Reset"),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _fetch,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final p = list[i];
                      return _ProductTile(product: p);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(productId: product.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.thumbnail,
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
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text("\$${product.price}", style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(product.category, style: const TextStyle(fontSize: 12)),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          cart.add(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Đã thêm vào giỏ ✅")),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        label: const Text("Thêm"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text("Chạm để xem chi tiết ➜", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
