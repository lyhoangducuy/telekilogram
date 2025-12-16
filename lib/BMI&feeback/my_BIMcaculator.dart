import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BmiCalculatorPage extends StatefulWidget {
  const BmiCalculatorPage({super.key});

  @override
  State<BmiCalculatorPage> createState() => _BmiCalculatorPageState();
}

class _BmiCalculatorPageState extends State<BmiCalculatorPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double? _bmiResult;
  String? _classification;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBmi() {
    if (_formKey.currentState!.validate()) {
      final double height = double.parse(_heightController.text);
      final double weight = double.parse(_weightController.text);

      if (height <= 0 || weight <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chiều cao và cân nặng phải lớn hơn 0'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final double bmi = weight / (height * height);
      final String classification = _getClassification(bmi);

      setState(() {
        _bmiResult = bmi;
        _classification = classification;
      });
    }
  }

  String _getClassification(double bmi) {
    if (bmi < 18.5) {
      return "Thiếu cân";
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return "Bình thường";
    } else if (bmi >= 25 && bmi <= 29.9) {
      return "Thừa cân";
    } else {
      return "Béo phì";
    }
  }

  Color _getClassificationColor(String? classification) {
    switch (classification) {
      case "Thiếu cân":
        return Colors.blue;
      case "Bình thường":
        return Colors.green;
      case "Thừa cân":
        return Colors.orange;
      case "Béo phì":
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color resultColor = _getClassificationColor(_classification);

    return Scaffold(
      // MÀU SẮC APPBAR GIỐNG ẢNH
      appBar: AppBar(
        title: const Text('Tính chỉ số BMI'),
        backgroundColor: Colors.teal[600], // Màu xanh ngọc đậm
        foregroundColor: Colors.white, // Chữ trắng
      ),
      // MÀU NỀN SCAFFOLD GIỐNG ẢNH
      backgroundColor: Colors.teal[50], // Màu xanh nhạt
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Căn trên
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Trường Chiều cao
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: 'Chiều cao (m)',
                  hintText: 'Ví dụ: 1.7',
                  prefixIcon: const Icon(Icons.height),
                  // BORDER GIỐNG ẢNH
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.white, // Nền trắng cho input
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập chiều cao';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0), // Khoảng cách giữa các ô input

              // Trường Cân nặng
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Cân nặng (kg)',
                  hintText: 'Ví dụ: 60.5',
                  prefixIcon: const Icon(Icons.monitor_weight_outlined),
                  // BORDER GIỐNG ẢNH
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.white, // Nền trắng cho input
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập cân nặng';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30.0), // Khoảng cách trước nút

              // Nút Tính BMI
              Center(
                child: ElevatedButton.icon(
                  onPressed: _calculateBmi,
                  icon: const Icon(Icons.calculate, color: Colors.white),
                  label: const Text(
                    'Tính BMI',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Màu xanh ngọc đậm hơn
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 30.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
              const SizedBox(height: 30.0), // Khoảng cách sau nút

              // --- Khu vực Hiển thị Kết quả ---
              if (_bmiResult != null)
                Column(
                  children: [
                    Text(
                      'Chỉ số BMI: ${_bmiResult!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24, // Kích thước lớn hơn
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Phân loại: $_classification',
                      style: TextStyle(
                        fontSize: 24, // Kích thước lớn hơn
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}