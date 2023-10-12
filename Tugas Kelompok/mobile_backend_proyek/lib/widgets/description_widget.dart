import 'package:flutter/material.dart';

class DescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchDescription(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text('Loading data...'), // Teks selama proses loading
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    color: Colors
                        .transparent, // Color of the container surrounding the image
                    width: 150.0,
                    height: 150.0,
                    child: Image.asset('assets/Nasa.jpeg',
                        width: 150, height: 150),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 270.0,
                  height: 180.0,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDADADA)),
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromRGBO(218, 218, 218, 0.3),
                  ),
                  child: Center(
                    child: Text(
                      snapshot.data!,
                      style:
                          const TextStyle(fontSize: 14.0, fontFamily: 'Lato'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('No data available.'),
          );
        }
      },
    );
  }

  Future<String> fetchDescription() async {
    await Future.delayed(const Duration(seconds: 2));
    print("Data dari deskripsi telah di download");

    return 'Cupang Movie adalah platform digital yang memungkinkan pengguna untuk menonton konten audio dan video melalui internet. Pengguna dapat mengakses berbagai jenis konten, seperti film, dan Acara TV';
  }
}
