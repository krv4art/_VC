import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  String _category = 'length';
  String _fromUnit = 'cm';
  String _toUnit = 'm';
  double _inputValue = 100;
  double _result = 1.0;

  final Map<String, Map<String, Map<String, dynamic>>> _conversions = {
    'length': {
      'cm': {'m': 0.01, 'km': 0.00001, 'mm': 10, 'in': 0.393701, 'ft': 0.0328084},
      'm': {'cm': 100, 'km': 0.001, 'mm': 1000, 'in': 39.3701, 'ft': 3.28084},
      'km': {'cm': 100000, 'm': 1000, 'mm': 1000000, 'in': 39370.1, 'ft': 3280.84},
    },
    'mass': {
      'g': {'kg': 0.001, 'mg': 1000, 'lb': 0.00220462, 'oz': 0.035274},
      'kg': {'g': 1000, 'mg': 1000000, 'lb': 2.20462, 'oz': 35.274},
      'lb': {'g': 453.592, 'kg': 0.453592, 'mg': 453592, 'oz': 16},
    },
    'temperature': {
      '°C': {'°F': (value) => value * 9 / 5 + 32, '°K': (value) => value + 273.15},
      '°F': {'°C': (value) => (value - 32) * 5 / 9, '°K': (value) => (value - 32) * 5 / 9 + 273.15},
      '°K': {'°C': (value) => value - 273.15, '°F': (value) => (value - 273.15) * 9 / 5 + 32},
    },
  };

  void _convert() {
    if (_fromUnit == _toUnit) {
      setState(() => _result = _inputValue);
      return;
    }

    final category = _conversions[_category]!;
    if (category[_fromUnit] != null && category[_fromUnit]![_toUnit] != null) {
      final conversion = category[_fromUnit]![_toUnit]!;
      setState(() {
        _result = conversion is Function ? conversion(_inputValue) : _inputValue * conversion;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Конвертер мір'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'length', label: Text('Довжина'), icon: Icon(Icons.straighten)),
                        ButtonSegment(value: 'mass', label: Text('Маса'), icon: Icon(Icons.scale)),
                        ButtonSegment(value: 'temperature', label: Text('Темп.'), icon: Icon(Icons.thermostat)),
                      ],
                      selected: {_category},
                      onSelectionChanged: (Set<String> selected) {
                        setState(() {
                          _category = selected.first;
                          _fromUnit = _conversions[_category]!.keys.first;
                          _toUnit = _conversions[_category]!.keys.toList()[1];
                          _convert();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Введіть значення',
                        border: const OutlineInputBorder(),
                        suffixText: _fromUnit,
                      ),
                      onChanged: (value) {
                        _inputValue = double.tryParse(value) ?? 0;
                        _convert();
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _fromUnit,
                            decoration: const InputDecoration(
                              labelText: 'З',
                              border: OutlineInputBorder(),
                            ),
                            items: _conversions[_category]!.keys.map((unit) {
                              return DropdownMenuItem(value: unit, child: Text(unit));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _fromUnit = value!;
                                _convert();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.arrow_forward, color: Colors.blue),
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _toUnit,
                            decoration: const InputDecoration(
                              labelText: 'В',
                              border: OutlineInputBorder(),
                            ),
                            items: _conversions[_category]!.keys.map((unit) {
                              return DropdownMenuItem(value: unit, child: Text(unit));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _toUnit = value!;
                                _convert();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade600]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text('Результат', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 8),
                          Text(
                            '${_result.toStringAsFixed(4)} $_toUnit',
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
