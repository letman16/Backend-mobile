import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyConverter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CurrencyConverterState();
  }
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double convertedAmount = 0.0;
  TextEditingController amountController = TextEditingController();
  String selectedFromCurrency = 'USD';
  String selectedToCurrency = 'IDR';

  bool hasilCV = false;
  Map<String, double> currencyRates = {};

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _convertCurrency() {
    final double amountToConvert = double.parse(amountController.text);
    final double fromRate = currencyRates[selectedFromCurrency] ?? 1;
    final double toRate = currencyRates[selectedToCurrency] ?? 1;

    setState(() {
      convertedAmount = amountToConvert * (toRate / fromRate);
      hasilCV = true;
    });
  }

  void _resetCV() {
    setState(() {
      selectedFromCurrency = 'USD';
      selectedToCurrency = 'IDR';

      amountController.text = '';
      convertedAmount = 0.0;
      hasilCV = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrencyData();
  }

  Future<void> _fetchCurrencyData() async {
    const apiKey = '284cc64f4a23195ac5abf948'; // Ganti dengan API Key Anda
    final url =
        'https://v6.exchangerate-api.com/v6/$apiKey/latest/$selectedFromCurrency';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          currencyRates = data['conversion_rates'].cast<String, double>();
        });
      } else {
        _showSnackBar(
            'Gagal mengambil data kurs mata uang. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyCodes = currencyRates.keys.toList();
    currencyCodes.sort();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Konversi Mata Uang'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButton<String>(
                  value: selectedFromCurrency,
                  items: currencyCodes.map((String code) {
                    return DropdownMenuItem<String>(
                      value: code,
                      child: Text(code),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFromCurrency = value!;
                    });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('ke'),
                ),
                DropdownButton<String>(
                  value: selectedToCurrency,
                  items: currencyCodes.map((String code) {
                    return DropdownMenuItem<String>(
                      value: code,
                      child: Text(code),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedToCurrency = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (hasilCV)
                  ElevatedButton(
                    onPressed: _resetCV,
                    child: const Text('Ulangi'),
                  ),
                if (!hasilCV)
                  ElevatedButton(
                    onPressed: _convertCurrency,
                    child: const Text('Konversi'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (hasilCV)
              Text('Hasil Konversi: $convertedAmount $selectedToCurrency'),
          ],
        ),
      ),
    );
  }
}
