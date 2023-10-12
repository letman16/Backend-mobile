import 'package:flutter/material.dart';
import 'package:latihan_praktek/db_helper.dart';
import 'package:latihan_praktek/model/history_data.dart';
import 'package:provider/provider.dart';
import 'MyProvider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    _dbHelper.getHistoryData().then((value) => tmp.setHistoryData = value);
    return Scaffold(
      appBar: AppBar(
        title: const Text("History Data Screen"),
        actions: [
          IconButton(
            onPressed: () {
              _dbHelper.deleteHistoryData();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("All history Data deleted"),
              ));
            },
            icon: const Icon(Icons.delete),
            tooltip: 'Delete all',
          )
        ],
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis
            .horizontal, // Memungkinkan scroll horizontal jika datanya melebihi layar
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('ID Reff'),
            ),
            DataColumn(
              label: Text('Event'),
            ),
            DataColumn(
              label: Text('Date'),
            ),
          ],
          rows: List<DataRow>.generate(
            tmp.getHistoryData.length,
            (int index) => DataRow(
              cells: <DataCell>[
                DataCell(Text(tmp.getHistoryData[index].id.toString())),
                DataCell(Text(tmp.getHistoryData[index].idRef.toString())),
                DataCell(Text(tmp.getHistoryData[index].event)),
                DataCell(Text(tmp.getHistoryData[index].date)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
