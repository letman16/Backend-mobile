import 'package:flutter/material.dart';

class DaftarPengguna extends StatefulWidget {
  const DaftarPengguna({super.key});

  @override
  State<DaftarPengguna> createState() => _DaftarPenggunaState();
}

class _DaftarPenggunaState extends State<DaftarPengguna> {
  dynamic data;

  Future<void> getUserData() {
    data = {
      [
        {"nim": "211111578", "nama": "LUKMAN HAKIM", "no_telp": "0812345678"}
      ],
      [
        {
          "nim": "123456789",
          "nama": "CINDY ANDITA PUTRI",
          "no_telp": "0876543210"
        }
      ],
    };
    return Future.delayed(const Duration(seconds: 3), () {
      print("Downloaded ${data.length} data");
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    print("Getting user data...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daftar Pengguna",
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Daftar Pengguna",
                style: Theme.of(context).textTheme.headline6),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('$data'),
            )
          ],
        ),
      ),
    );
  }
}
