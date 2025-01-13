import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _input = '';
  String _result = '0';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _result = '0';
      } else if (value == '=') {
        try {
          _result = _calculateResult(_input);
        } catch (e) {
          _result = 'Erro';
        }
      } else {
        _input += value;
      }
    });
  }

  String _calculateResult(String expression) {
    try {
      final parsedExpression = expression.replaceAll('x', '*');
      final evaluator = ExpressionEvaluator();
      final result = evaluator.evaluate(parsedExpression);
      return result == result.toInt() ? result.toInt().toString() : result.toString();
    } catch (e) {
      return 'Erro';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              color: Colors.pink[50], // Fundo rosa claro
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _input,
                    style: const TextStyle(fontSize: 24, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _result,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildKeypad(),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    final buttons = [
      ['7', '8', '9', '/'],
      ['4', '5', '6', 'x'],
      ['1', '2', '3', '-'],
      ['C', '0', '=', '+'],
    ];

    return Column(
      children: buttons.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((buttonText) {
            return _buildButton(buttonText);
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent, // Botões rosa mais escuro
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Cantos arredondados
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ExpressionEvaluator {
  double evaluate(String expression) {
    final tokens = _tokenize(expression);
    double result = double.parse(tokens[0]);

    for (int i = 1; i < tokens.length; i += 2) {
      final operator = tokens[i];
      final value = double.parse(tokens[i + 1]);
      switch (operator) {
        case '+':
          result += value;
          break;
        case '-':
          result -= value;
          break;
        case '*':
          result *= value;
          break;
        case '/':
          result /= value;
          break;
        default:
          throw Exception('Operador inválido');
      }
    }

    return result;
  }

  List<String> _tokenize(String expression) {
    final regex = RegExp(r'(\d+\.?\d*|\+|\-|\*|\/)');
    final matches = regex.allMatches(expression);
    return matches.map((m) => m.group(0)!).toList();
  }
}





