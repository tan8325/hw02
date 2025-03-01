import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '';
  String _operator = '';
  double? _firstOperand;
  double? _secondOperand;

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _clear();
      } else if ('+-*/'.contains(value)) {
        _setOperator(value);
      } else if (value == '=') {
        _calculateResult();
      } else {
        _display += value;
      }
    });
  }

  void _clear() {
    _display = '';
    _operator = '';
    _firstOperand = null;
    _secondOperand = null;
  }

  void _setOperator(String value) {
    if (_display.isNotEmpty) {
      _firstOperand = double.tryParse(_display);
      _operator = value;
      _display = '';
    }
  }

  void _calculateResult() {
    if (_firstOperand != null && _operator.isNotEmpty && _display.isNotEmpty) {
      _secondOperand = double.tryParse(_display);
      double? result;
      switch (_operator) {
        case '+':
          result = _firstOperand! + _secondOperand!;
          break;
        case '-':
          result = _firstOperand! - _secondOperand!;
          break;
        case '*':
          result = _firstOperand! * _secondOperand!;
          break;
        case '/':
          result = _secondOperand == 0 ? double.nan : _firstOperand! / _secondOperand!;
          break;
      }
      _display = result?.toStringAsFixed(2) ?? 'Error';
      _operator = '';
      _firstOperand = null;
      _secondOperand = null;
    }
  }

  Widget _buildButton(String label, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[800],
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => _onPressed(label),
          child: Text(
            label,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16),
              child: Text(
                _display,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          for (var row in [
            ['7', '8', '9', '/'],
            ['4', '5', '6', '*'],
            ['1', '2', '3', '-'],
            ['C', '0', '=', '+']
          ])
            Row(
              children: row.map((label) => _buildButton(label, color: (label == '=' || label == 'C') ? Colors.orange : null)).toList(),
            ),
        ],
      ),
    );
  }
}
