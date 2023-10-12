import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final int index;
  final List<Map<String, String>> detailData;

  const ProfileWidget({
    required this.index,
    required this.detailData,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchProfileData(index),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Column(
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(snapshot.data!['imageUrl']),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                '${snapshot.data!['Nama']}',
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5.0),
              Text(
                '${snapshot.data!['Nim']}',
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          );
        } else {
          return const Text('No data available.');
        }
      },
    );
  }

  Future<Map<String, dynamic>> fetchProfileData(int index) async {
    await Future.delayed(const Duration(seconds: 5));

    print("Downloaded ${detailData.length} Profile Dev...");

    return {
      'Nama': detailData[index]['Nama']!,
      'Nim': detailData[index]['Nim']!,
      'imageUrl': detailData[index]['imageUrl']!,
    };
  }
}
