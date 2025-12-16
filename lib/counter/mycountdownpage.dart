import 'package:flutter/material.dart';
import 'dart:async'; 
import 'package:flutter/services.dart'; 
import 'package:telekilogram/HomePage.dart';
class CountDownPage extends StatefulWidget {
  const CountDownPage({super.key});

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {

  int _counter = 0;


  Timer? _stopwatchTimer;
  int _stopwatchSeconds = 0;
  bool _isStopwatchRunning = false;

 
  final TextEditingController _countdownController = TextEditingController();
  Timer? _countdownTimer;
  int _countdownSeconds = 0;
  bool _isCountdownRunning = false;


  @override
  void dispose() {
    _stopwatchTimer?.cancel();
    _countdownTimer?.cancel();
    _countdownController.dispose();
    super.dispose();
  }


  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }


  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60; 
    final int seconds = totalSeconds % 60;
    final int miliseconds = totalSeconds % 1;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _startStopwatch() {
    if (!_isStopwatchRunning) {
      _isStopwatchRunning = true;

      _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _stopwatchSeconds++;
        });
      });
    }
  }

  void _stopStopwatch() {
    _stopwatchTimer?.cancel();
    setState(() {
      _isStopwatchRunning = false;
    });
  }

  void _resetStopwatch() {
    _stopwatchTimer?.cancel();
    setState(() {
      _stopwatchSeconds = 0;
      _isStopwatchRunning = false;
    });
  }

  void _startCountdown() {
    if (!_isCountdownRunning && _countdownSeconds > 0) {
      _isCountdownRunning = true;
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_countdownSeconds > 0) {
          setState(() {
            _countdownSeconds--;
          });
        } else {
          _stopCountdown();
          _showTimeUpDialog();
        }
      });
    }
  }

  void _stopCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _isCountdownRunning = false;
    });
  }

  void _resetCountdownTimer() {
    _countdownTimer?.cancel();
    int inputSeconds = int.tryParse(_countdownController.text) ?? 0;
    setState(() {
      _countdownSeconds = inputSeconds;
      _isCountdownRunning = false;
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hết thời gian!'),
          
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppNavigationDrawer(),
      appBar: AppBar(
        title: const Text('Bộ đếm Thời gian'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              

              const Text(
                'Số giây cần đếm',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16),
                child: TextField(
                  controller: _countdownController,
                  decoration: const InputDecoration(
                    labelText: 'Nhập số giây',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly 
                  ],
                  onChanged: (value) {
                    if (!_isCountdownRunning) {
                      setState(() {
                        _countdownSeconds = int.tryParse(value) ?? 0;
                      });
                    }
                  },
                ),
              ),
              Text(
                _formatTime(_countdownSeconds),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:
                        _isCountdownRunning || _countdownSeconds == 0
                            ? null
                            : _startCountdown,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                        
                    child: const Text('Bắt đầu'),
                  ),
                  const SizedBox(width: 16),
                  
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _resetCountdownTimer,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text('Đặt lại'),
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