import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Import package untuk memformat tanggal

class MyBio extends StatefulWidget {
  const MyBio({Key? key}) : super(key: key);

  @override
  State<MyBio> createState() => _MyBioState();
}

class _MyBioState extends State<MyBio> {
  String? _image;
  double _score = 0;
  final ImagePicker _picker = ImagePicker();
  final String _keyScore = 'score';
  final String _keyImage = 'image';
  final String _keyBirthday = 'birthday'; // Tambahkan kunci untuk tanggal
  DateTime? _birthday; // Tambahkan variabel untuk tanggal
  late SharedPreferences prefs;

  void loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = (prefs.getDouble(_keyScore) ?? 0);
      _image = prefs.getString(_keyImage);
      // Muat tanggal dari SharedPreferences
      final birthdayString = prefs.getString(_keyBirthday);
      if (birthdayString != null) {
        _birthday = DateTime.parse(birthdayString);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> _setScore(double value) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble(_keyScore, value);
      _score = ((prefs.getDouble(_keyScore) ?? 0));
    });
  }

  Future<void> _setImage(String? value) async {
    prefs = await SharedPreferences.getInstance();
    if (value != null) {
      setState(() {
        prefs.setString(_keyImage, value);
        _image = ((prefs.getString(_keyImage)));
      });
    }
  }

  // Fungsi untuk menyimpan tanggal ke SharedPreferences
  Future<void> _setBirthday(DateTime? value) async {
    prefs = await SharedPreferences.getInstance();
    if (value != null) {
      final birthdayString = DateFormat('yyyy-MM-dd').format(value);
      setState(() {
        prefs.setString(_keyBirthday, birthdayString);
        _birthday = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bio"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: _image != null
                    ? Image.file(
                        File(_image!),
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.fitHeight,
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 198, 198, 198),
                        ),
                        width: 200,
                        height: 200,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    _setImage(image?.path);
                  },
                  child: const Text("Take Image"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SpinBox(
                  max: 10.0,
                  min: 0.0,
                  value: _score,
                  decimals: 1,
                  step: 0.1,
                  decoration: const InputDecoration(labelText: 'Decimals'),
                  onChanged: _setScore,
                ),
              ),
              // Tampilkan tanggal yang telah dimasukkan
              _birthday != null
                  ? Text(
                      'Tanggal Lahir: ${DateFormat('dd/MM/yyyy').format(_birthday!)}',
                      style: TextStyle(fontSize: 16),
                    )
                  : Container(),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    _setBirthday(selectedDate);
                  }
                },
                child: const Text("Pilih Tanggal Lahir"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
