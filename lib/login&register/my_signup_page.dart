import 'package:flutter/material.dart';
// Import trang Login để điều hướng (đảm bảo đường dẫn đúng với dự án của bạn)
import 'my_Login_Page.dart'; 

// Đây là class cho trang Đăng Ký, một StatefulWidget
class MySignupPage extends StatefulWidget {
  const MySignupPage({super.key});

  @override
  State<MySignupPage> createState() => _MySignupPageState();
}

class _MySignupPageState extends State<MySignupPage> {
  // GlobalKey để định danh và quản lý Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller để lấy dữ liệu từ các trường text
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Biến trạng thái để ẩn/hiện mật khẩu
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Hủy các controller khi widget bị xóa (để tránh rò rỉ bộ nhớ)
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Hàm xử lý khi nhấn nút "Đăng ký"
  void _submitForm() {
    // Kích hoạt validation của Form
    // Nếu tất cả các trường đều hợp lệ, 'validate()' trả về 'true'
    if (_formKey.currentState!.validate()) {
      // Nếu hợp lệ, hiển thị một SnackBar (thông báo)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký tài khoản thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      // Ở đây bạn có thể thêm logic gửi dữ liệu lên server, v.v.
    } else {
      // Nếu không hợp lệ, hiển thị SnackBar lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng kiểm tra lại thông tin đã nhập.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Xây dựng giao diện (UI)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo tài khoản mới'),
        backgroundColor: Colors.indigo, // Màu nền cho AppBar
        foregroundColor: Colors.white,
      ),
      // Dùng Center và SingleChildScrollView để form ở giữa và cuộn được
      // khi bàn phím hiện lên
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          // Sử dụng Card để tạo giao diện hộp như trong ảnh
          child: Card(
            elevation: 8.0, // Thêm bóng mờ
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            // ClipRRect để bo góc cho phần header màu
            child: Column(
              mainAxisSize: MainAxisSize.min, // Giới hạn kích thước Card
              children: [
                // Header màu xanh
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.indigo[600],
                  child: const Text(
                    'Form Đăng ký tài khoản',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Form
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey, // Gắn key cho Form
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Trường Họ tên
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Họ tên',
                            helperText: 'Vui lòng nhập họ tên',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          // Quy tắc kiểm tra (validate)
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Họ tên không được để trống';
                            }
                            return null; // Hợp lệ
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Trường Email
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            helperText: 'Vui lòng nhập email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email không được để trống';
                            }
                            // Kiểm tra định dạng email cơ bản
                            if (!value.contains('@') ||
                                !value.contains('.')) {
                              return 'Email không đúng định dạng';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Trường Mật khẩu
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword, // Ẩn mật khẩu
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            helperText: 'Vui lòng nhập mật khẩu',
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            // Icon để ẩn/hiện mật khẩu
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                // Cập nhật trạng thái để vẽ lại UI
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mật khẩu không được để trống';
                            }
                            if (value.length < 6) {
                              return 'Mật khẩu phải có ít nhất 6 ký tự';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Trường Xác nhận mật khẩu
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText:
                              _obscureConfirmPassword, // Ẩn mật khẩu
                          decoration: InputDecoration(
                            labelText: 'Xác nhận mật khẩu',
                            helperText: 'Vui lòng xác nhận mật khẩu',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            // Icon để ẩn/hiện mật khẩu
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng xác nhận mật khẩu';
                            }
                            // Kiểm tra trùng khớp với mật khẩu đã nhập
                            if (value != _passwordController.text) {
                              return 'Mật khẩu không trùng khớp';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24.0),

                        // Nút Đăng ký
                        ElevatedButton(
                          onPressed: _submitForm, // Gọi hàm xử lý
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Đăng ký',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ),

                        const SizedBox(height: 16.0),

                        // --- MỚI: Phần Chuyển sang Đăng nhập ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Đã có tài khoản? "),
                            GestureDetector(
                              onTap: () {
                                // Chuyển sang trang Đăng nhập
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              },
                              child: Text(
                                "Đăng nhập ngay",
                                style: TextStyle(
                                  color: Colors.indigo[700],
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}