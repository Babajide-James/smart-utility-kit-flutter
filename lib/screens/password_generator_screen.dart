import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  double _length = 12;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  String _password = '';

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _generatePassword() {
    String lower = 'abcdefghijklmnopqrstuvwxyz';
    String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String numbers = '0123456789';
    String symbols = '!@#\$%^&*()-_=+';

    String chars = '';
    if (_includeLowercase) chars += lower;
    if (_includeUppercase) chars += upper;
    if (_includeNumbers) chars += numbers;
    if (_includeSymbols) chars += symbols;

    if (chars.isEmpty) {
      setState(() {
        _password = 'Select at least one option';
      });
      return;
    }

    Random rnd = Random();
    String generated = String.fromCharCodes(
      Iterable.generate(
        _length.toInt(),
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );

    setState(() {
      _password = generated;
    });
  }

  void _copyToClipboard() {
    if (_password.isNotEmpty && _password != 'Select at least one option') {
      Clipboard.setData(ClipboardData(text: _password));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password copied to clipboard!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Password Display
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    _password,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _copyToClipboard,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy to Clipboard'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Length Slider
            const Text('Password Length', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text(_length.toInt().toString(), style: const TextStyle(fontSize: 16)),
                Expanded(
                  child: Slider(
                    value: _length,
                    min: 6,
                    max: 32,
                    divisions: 26,
                    label: _length.toInt().toString(),
                    onChanged: (val) {
                      setState(() {
                        _length = val;
                        _generatePassword();
                      });
                    },
                  ),
                ),
              ],
            ),
            const Divider(),

            // Toggles
            _buildSwitch('Include Uppercase', _includeUppercase, (val) {
              setState(() => _includeUppercase = val);
              _generatePassword();
            }),
            _buildSwitch('Include Lowercase', _includeLowercase, (val) {
              setState(() => _includeLowercase = val);
              _generatePassword();
            }),
            _buildSwitch('Include Numbers', _includeNumbers, (val) {
              setState(() => _includeNumbers = val);
              _generatePassword();
            }),
            _buildSwitch('Include Symbols', _includeSymbols, (val) {
              setState(() => _includeSymbols = val);
              _generatePassword();
            }),
            
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _generatePassword,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text('Regenerate Password'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}
