import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class MyApp extends CalculatorApp {
  const MyApp({super.key});
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: CalculatorScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: (value) => setState(() => isDarkMode = value),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const CalculatorScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  String previousValue = '';
  String operation = '';
  bool shouldResetDisplay = false;

  void onNumberPressed(String number) {
    setState(() {
      if (shouldResetDisplay) {
        display = number;
        shouldResetDisplay = false;
      } else {
        display = display == '0' ? number : display + number;
      }
    });
  }

  void onDecimalPressed() {
    setState(() {
      if (!display.contains('.')) display += '.';
    });
  }

  void onOperationPressed(String value) {
    if (operation.isNotEmpty && !shouldResetDisplay) calculateResult();
    setState(() {
      previousValue = display;
      operation = value;
      shouldResetDisplay = true;
    });
  }

  void calculateResult() {
    if (previousValue.isEmpty || operation.isEmpty) return;
    final first = double.tryParse(previousValue) ?? 0;
    final second = double.tryParse(display) ?? 0;
    final result = switch (operation) {
      '+' => first + second,
      '−' => first - second,
      '×' => first * second,
      '÷' => second == 0 ? 0 : first / second,
      '%' => second == 0 ? 0 : first % second,
      _ => second,
    };
    setState(() {
      display = _formatNumber(result.toDouble());
      previousValue = '';
      operation = '';
      shouldResetDisplay = true;
    });
  }

  void clear() => setState(() {
    display = '0';
    previousValue = '';
    operation = '';
    shouldResetDisplay = false;
  });

  void backspace() => setState(() {
    display = display.length > 1 ? display.substring(0, display.length - 1) : '0';
  });

  String _formatNumber(double value) {
    if (value == value.toInt()) return value.toInt().toString();
    return value.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.isDarkMode;
    final textColor = dark ? Colors.white : const Color(0xFF333333);
    final numberColor = dark ? const Color(0xFF333333) : const Color(0xFFE8E8E8);
    const operatorColor = Color(0xFF5B6BFF);
    return Scaffold(
      backgroundColor: dark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Calculadora', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor)),
                  IconButton(
                    icon: Icon(dark ? Icons.light_mode : Icons.dark_mode, color: operatorColor),
                    onPressed: () => widget.onThemeChanged(!dark),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: dark ? const Color(0xFF0D0D0D) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$previousValue$operation', style: TextStyle(fontSize: 18, color: textColor.withOpacity(.6))),
                    const SizedBox(height: 12),
                    Text(display.replaceAll('.', ','), style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300, color: textColor)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _button('C', textColor, numberColor, clear),
                    _button('/', textColor, operatorColor, () => onOperationPressed('÷')),
                    _button('%', textColor, operatorColor, () => onOperationPressed('%')),
                    _button('÷', textColor, operatorColor, () => onOperationPressed('÷')),
                    for (final row in [
                      ['7', '8', '9', '×'],
                      ['4', '5', '6', '−'],
                      ['1', '2', '3', '+'],
                    ])
                      for (final label in row)
                        _button(label, textColor, '+−×÷'.contains(label) ? operatorColor : numberColor, () => '+−×÷'.contains(label) ? onOperationPressed(label) : onNumberPressed(label)),
                    _button('.', textColor, numberColor, onDecimalPressed),
                    _button('0', textColor, numberColor, () => onNumberPressed('0')),
                    _button('⌫', textColor, numberColor, backspace),
                    _button('=', textColor, operatorColor, calculateResult),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(String label, Color textColor, Color backgroundColor, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        child: Center(child: Text(label, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: backgroundColor == const Color(0xFF5B6BFF) ? Colors.white : textColor))),
      ),
    );
  }
}
