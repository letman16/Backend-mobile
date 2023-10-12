import 'package:flutter/material.dart';
import 'package:mobile_backend_proyek/widgets/profile_widget.dart';
import 'package:mobile_backend_proyek/widgets/description_widget.dart';
import 'dart:async';

class AboutPage extends StatelessWidget {
  Stream<List<Map<String, String>>> detailDataStream = Stream.fromIterable([
    [
      {
        'Nama': 'M. Natasya Ramadana',
        'Nim': '211112080',
        'imageUrl': 'assets/Nasa.jpeg',
      },
      {
        'Nama': 'Frendika Sembiring',
        'Nim': '211112142',
        'imageUrl': 'assets/Frendika.jpeg',
      },
      {
        'Nama': 'M. Aulia Kahfi',
        'Nim': '211112562',
        'imageUrl': 'assets/Aulia.jpeg',
      },
      {
        'Nama': 'Lukman Hakim',
        'Nim': '211111578',
        'imageUrl': 'assets/Lukman.jpeg',
      },
    ],
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupang Movie'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Tentang',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Color(0xFFFF8F71),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' Aplikasi',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              DescriptionWidget(),
              const SizedBox(height: 20.0),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Tentang',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Color(0xFFFF8F71),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' Kami',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<List<Map<String, String>>>(
                stream: detailDataStream, // Gunakan stream yang telah kita buat
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Menggunakan data dari stream untuk mengisi GridView
                    List<Map<String, String>> detailData = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        children: List.generate(
                          detailData.length,
                          (index) => ProfileWidget(
                              index: index, detailData: detailData),
                        ),
                      ),
                    );
                  } else {
                    return const Text(
                        'Waiting for data...'); // Menampilkan pesan saat data masih belum tersedia
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
