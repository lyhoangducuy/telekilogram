import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // Key để quản lý Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Danh sách các lựa chọn cho Dropdown
  final List<String> _ratingOptions = [
    '1 sao',
    '2 sao',
    '3 sao',
    '4 sao',
    '5 sao'
  ];
  // Biến trạng thái lưu giá trị đang chọn (mặc định là '4 sao' giống ảnh)
  String? _selectedRating = '4 sao';

  @override
  void dispose() {
    _nameController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Hàm xử lý khi gửi Form
  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // Lấy dữ liệu
      final String name = _nameController.text;
      final String rating = _selectedRating!;
      final String content = _contentController.text;

      // In ra console (để kiểm tra)
      print('Họ tên: $name');
      print('Đánh giá: $rating');
      print('Nội dung: $content');

      // Hiển thị SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gửi phản hồi thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      // (Tùy chọn) Xóa nội dung Form sau khi gửi
      _formKey.currentState!.reset();
      _nameController.clear();
      _contentController.clear();
      setState(() {
        _selectedRating = '4 sao';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Màu chủ đạo (giống trong ảnh)
    final Color primaryColor = Colors.deepOrange[600]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gửi phản hồi'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.deepOrange[50], // Nền màu cam nhạt
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Trường Họ tên
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Họ tên',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              // Trường Đánh giá (Dropdown)
              DropdownButtonFormField<String>(
                value: _selectedRating, // Giá trị đang được chọn
                items: _ratingOptions.map((String rating) {
                  return DropdownMenuItem<String>(
                    value: rating,
                    child: Text(rating),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRating = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Đánh giá (1 - 5 sao)',
                  prefixIcon: const Icon(Icons.star_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn đánh giá';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              // Trường Nội dung góp ý
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Nội dung góp ý',
                  // Dùng alignLabelWithHint để icon và label căn lên trên
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 80.0), // Đẩy icon lên
                    child: Icon(Icons.comment_outlined),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 5, // Ô nhập liệu nhiều dòng
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung góp ý';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30.0),

              // Nút Gửi phản hồi
              ElevatedButton.icon(
                onPressed: _submitFeedback,
                // (Tùy chọn) Giảm size icon một chút nếu muốn gọn hơn
                icon: const Icon(Icons.send, color: Colors.white, size: 20), 
                label: const Text(
                  'Gửi phản hồi',
                  // (Tùy chọn) Giảm fontSize xuống 16 để nút ngắn lại
                  style: TextStyle(fontSize: 16.0, color: Colors.white), 
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  
                  // 1. Giảm padding ngang xuống 12 (hoặc 8 nếu muốn sát hơn nữa)
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  
                  // 2. Cho phép nút nhỏ hơn kích thước mặc định
                  minimumSize: Size.zero, 
                  
                  // 3. Yêu cầu nút co lại vừa khít với nội dung
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, 
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}