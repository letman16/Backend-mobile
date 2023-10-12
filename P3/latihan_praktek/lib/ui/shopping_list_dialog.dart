import 'package:flutter/material.dart';
import 'package:latihan_praktek/db_helper.dart';
import 'package:latihan_praktek/model/ShoppingList.dart';

class ShoppingListDialog {
  DBHelper _dbHelper;
  ShoppingListDialog(this._dbHelper);

  final txtName = TextEditingController();
  final txtSum = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    if (!isNew) {
      txtName.text = list.name;
      txtSum.text = list.sum.toString();
    } else {
      txtName.text = "";
      txtSum.text = "";
    }
    return AlertDialog(
      title: Text((isNew) ? 'New Shopping List' : 'Edit Shopping List'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: "Shopping List Name"),
            ),
            TextField(
              controller: txtSum,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Sum'),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text("Save Shopping List"),
                  onPressed: () {
                    list.name = txtName.text != "" ? txtName.text : "Empty";
                    list.sum = txtSum.text != "" ? int.parse(txtSum.text) : 0;
                    _dbHelper.insertShoppingList(list);
                    Navigator.pop(context);
                  },
                ))
          ],
        ),
      ),
    );
  }
}
