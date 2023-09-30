import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Contoh2 extends StatefulWidget {
  const Contoh2({Key? key}) : super(key: key);

  @override
  State<Contoh2> createState() => _Contoh2State();
}

class _Contoh2State extends State<Contoh2> {
  List<Map<String, String>> data = []; // Inisialisasi sebagai List kosong
  int percent = 100;
  int getStream = 0;
  double circular = 1;
  var indikatorText = "Full";
  int valPercent = 100;

  late StreamSubscription _sub;
  final Stream _myStream =
      Stream.periodic(const Duration(seconds: 1), (int count) {
    return count;
  });

  String stsPlay = "0";

  void _reset() {
    setState(() {
      percent = 100;
      circular = 1.0;
      _sub.pause();
      indikatorText = "Full";
      valPercent = 100;
    });
  }

  void _stop() {
    _sub.pause(); // Jeda stream ketika tombol "Stop" ditekan
  }

  void _play() {
    setState(() {
      stsPlay = "1";
    });
    _sub.resume(); // Lanjutkan stream ketika tombol "Play" ditekan
  }

  void _indikatorText(valPercent) {
    print(valPercent);
    if (valPercent == 0) {
      setState(() {
        indikatorText = "Empty";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("Getting user data...");

    _sub = _myStream.listen((event) {
      getStream = event;

      setState(() {
        if (stsPlay == "1") {
          if (percent - getStream < 0) {
            _sub.cancel();
            percent = 0;
            circular = 0;
            _indikatorText(percent);
          } else {
            percent = percent - getStream;
            circular = percent / 100;
            _indikatorText(percent);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contoh 2",
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 100,
              lineWidth: 10,
              percent: circular,
              center: Text("$percent %"),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Daftar Pengguna",
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: FutureBuilder(
                future: getUserData(), // Gunakan Future dari getUserData
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Tampilkan indikator jika data sedang diambil
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData ||
                      (snapshot.data as List).isEmpty) {
                    // Tangani kasus ketika data kosong
                    return const Text('Data pengguna kosong');
                  } else {
                    // Jika data tersedia, bangun ListView.builder
                    data = snapshot.data as List<Map<String, String>>;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return _buildListItem(
                            index); // Gunakan fungsi _buildListItem
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Indikator Text",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                indikatorText,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: _reset,
            child: const Text("Reset"),
          ),
          FloatingActionButton(
            onPressed: _play,
            child: const Text("Play"),
          ),
          FloatingActionButton(
            onPressed: _stop,
            child: const Text("Stop"),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(int index) {
    final item = data[index];
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        title: Text("NIM: ${item['nim']}"),
        subtitle: Text("Nama: ${item['nama']}"),
        trailing: Text("No. Telp: ${item['no_telp']}"),
      ),
    );
  }

  Future<List<Map<String, String>>> getUserData() async {
    await Future.delayed(const Duration(seconds: 5));
    return [
      {"nim": "211111578", "nama": "LUKMAN HAKIM", "no_telp": "0812345678"},
      {
        "nim": "123456789",
        "nama": "CINDY ANDITA PUTRI",
        "no_telp": "0876543210"
      },
    ];
  }
}
