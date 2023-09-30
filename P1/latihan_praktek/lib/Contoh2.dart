import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Contoh2 extends StatefulWidget {
  const Contoh2({super.key});

  @override
  State<Contoh2> createState() => _Contoh2State();
}

class _Contoh2State extends State<Contoh2> {
  int Percent = 100;
  int getStream = 0;
  double circular = 1;

  late StreamSubscription _sub;
  final Stream _myStream =
      Stream.periodic(const Duration(seconds: 1), (int count) {
    return count;
  });

  var stsPlay = "0";
  @override
  void initState() {
    super.initState();
    _sub = _myStream.listen((event) {
      getStream = event;
      setState(() {
        if (stsPlay == "1") {
          if (Percent - getStream < 0) {
            _sub.cancel();
            Percent = 0;
            circular = 0;
          } else {
            Percent = Percent - getStream;
            circular = Percent / 100;
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

  void _reset() {
    setState(() {
      Percent = 100;
      circular = 1.0;
      _sub.pause();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contoh 2",
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Center(child: LayoutBuilder(
        builder: (context, Constraints) {
          final double avaWidth = Constraints.maxWidth;
          final double avaHeight = Constraints.maxHeight;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: CircularPercentIndicator(
                radius: avaHeight / 5,
                lineWidth: 10,
                percent: circular,
                center: Text("$Percent %"),
              ))
            ],
          );
        },
      )),
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
}
