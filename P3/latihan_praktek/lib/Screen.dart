import 'package:flutter/material.dart';
import 'package:latihan_praktek/db_helper.dart';
import 'package:latihan_praktek/history_screen.dart';
import 'package:provider/provider.dart';
import 'MyProvider.dart';
import 'ItemScreen.dart';
import 'model/ShoppingList.dart';
import 'ui/shopping_list_dialog.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int idInsertdata = 0;
  int idInsertHistory = 0;
  final DBHelper _dbHelper = DBHelper();

  @override
  void dispose() {
    _dbHelper.closeDB();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    _dbHelper.getMyShoppingList().then((value) => tmp.setShoppingList = value);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Shopping List"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HistoryScreen()),
                  );
                },
                child: const Text("History")),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                _dbHelper.deleteShoppingList();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("All Shopping List deleted"),
                ));
              },
              icon: const Icon(Icons.delete),
              tooltip: 'Delete all',
            )
          ],
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
            itemCount:
                // ignore: unnecessary_null_comparison
                tmp.getShoppingList != null ? tmp.getShoppingList.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                  key: Key(tmp.getShoppingList[index].id.toString()),
                  onDismissed: (direction) {
                    String tmpName = tmp.getShoppingList[index].name;
                    int tmpId = tmp.getShoppingList[index].id;
                    // Pindahkan data ke tabel history_data
                    _dbHelper.moveToHistory(tmp.getShoppingList[index]);
                    setState(() {
                      tmp.deleteById(tmp.getShoppingList[index]);
                    });

                    _dbHelper.deleteShoppingListById(tmpId);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$tmpName deleted"),
                    ));
                  },
                  child: ListTile(
                    title: Text(tmp.getShoppingList[index].name),
                    leading: CircleAvatar(
                      child: Text("${tmp.getShoppingList[index].sum}"),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ItemScreen(tmp.getShoppingList[index]);
                      }));
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ShoppingListDialog(_dbHelper).buildDialog(
                                  context, tmp.getShoppingList[index], false);
                            });
                        _dbHelper
                            .getMyShoppingList()
                            .then((value) => tmp.setShoppingList = value);
                      },
                    ),
                  ));
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return ShoppingListDialog(_dbHelper).buildDialog(
                      context, ShoppingList(++idInsertdata, "", 0), true);
                });
            _dbHelper
                .getMyShoppingList()
                .then((value) => tmp.setShoppingList = value);
          },
          child: const Icon(Icons.add),
        ));
  }
}
