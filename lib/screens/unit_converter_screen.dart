import 'package:flutter/material.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  String _selectedCategory = 'Length';
  String _fromUnit = 'Meters';
  String _toUnit = 'Feet';
  final TextEditingController _inputController = TextEditingController();
  String _result = '0.0';

  final Map<String, List<String>> _categories = {
    'Length': ['Meters', 'Kilometers', 'Centimeters', 'Miles', 'Yards', 'Feet', 'Inches'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Weight': ['Kilograms', 'Grams', 'Pounds', 'Ounces'],
  };

  void _convert() {
    double input = double.tryParse(_inputController.text) ?? 0.0;
    double output = 0.0;

    if (_selectedCategory == 'Length') {
      output = _convertLength(input, _fromUnit, _toUnit);
    } else if (_selectedCategory == 'Temperature') {
      output = _convertTemperature(input, _fromUnit, _toUnit);
    } else if (_selectedCategory == 'Weight') {
      output = _convertWeight(input, _fromUnit, _toUnit);
    }

    setState(() {
      _result = output.toStringAsFixed(4).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
    });
  }

  double _convertLength(double value, String from, String to) {
    // Convert to Meters first
    double inMeters = value;
    switch (from) {
      case 'Kilometers': inMeters = value * 1000; break;
      case 'Centimeters': inMeters = value / 100; break;
      case 'Miles': inMeters = value * 1609.34; break;
      case 'Yards': inMeters = value * 0.9144; break;
      case 'Feet': inMeters = value * 0.3048; break;
      case 'Inches': inMeters = value * 0.0254; break;
    }

    // Convert from Meters to Target
    switch (to) {
      case 'Meters': return inMeters;
      case 'Kilometers': return inMeters / 1000;
      case 'Centimeters': return inMeters * 100;
      case 'Miles': return inMeters / 1609.34;
      case 'Yards': return inMeters / 0.9144;
      case 'Feet': return inMeters / 0.3048;
      case 'Inches': return inMeters / 0.0254;
      default: return inMeters;
    }
  }

  double _convertTemperature(double value, String from, String to) {
    if (from == to) return value;
    double inCelsius = value;
    
    // To Celsius
    if (from == 'Fahrenheit') {
      inCelsius = (value - 32) * 5 / 9;
    } else if (from == 'Kelvin') {
      inCelsius = value - 273.15;
    }

    // From Celsius
    if (to == 'Celsius') return inCelsius;
    if (to == 'Fahrenheit') return (inCelsius * 9 / 5) + 32;
    if (to == 'Kelvin') return inCelsius + 273.15;
    
    return inCelsius;
  }

  double _convertWeight(double value, String from, String to) {
    // Convert to Grams first
    double inGrams = value;
    switch (from) {
      case 'Kilograms': inGrams = value * 1000; break;
      case 'Pounds': inGrams = value * 453.592; break;
      case 'Ounces': inGrams = value * 28.3495; break;
    }

    switch (to) {
      case 'Grams': return inGrams;
      case 'Kilograms': return inGrams / 1000;
      case 'Pounds': return inGrams / 453.592;
      case 'Ounces': return inGrams / 28.3495;
      default: return inGrams;
    }
  }

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_convert);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Converter'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: _categories.keys.map((String category) {
                    return DropdownMenuItem(value: category, child: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                        _fromUnit = _categories[value]!.first;
                        _toUnit = _categories[value]![1 % _categories[value]!.length]; // Select second as default if available
                        _convert();
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // From
            _buildUnitSection(
              title: 'From',
              selectedUnit: _fromUnit,
              units: _categories[_selectedCategory]!,
              onChanged: (val) {
                setState(() => _fromUnit = val!);
                _convert();
              },
              child: TextField(
                controller: _inputController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                ),
              ),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: Icon(Icons.swap_vert, size: 32, color: Colors.grey)),
            ),

            // To
            _buildUnitSection(
              title: 'To',
              selectedUnit: _toUnit,
              units: _categories[_selectedCategory]!,
              onChanged: (val) {
                setState(() => _toUnit = val!);
                _convert();
              },
              child: Text(
                _result,
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitSection({
    required String title,
    required String selectedUnit,
    required List<String> units,
    required ValueChanged<String?> onChanged,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedUnit,
              isExpanded: true,
              items: units.map((String unit) {
                return DropdownMenuItem(value: unit, child: Text(unit, style: const TextStyle(fontSize: 18)));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
          const Divider(),
          child,
        ],
      ),
    );
  }
}
