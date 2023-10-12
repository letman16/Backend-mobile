import 'package:flutter/material.dart';
import 'package:latihan_praktek/model/history_data.dart';
import 'model/ShoppingList.dart';

class ListProductProvider extends ChangeNotifier {
  List<ShoppingList> _shoppingList = [];
  List<ShoppingList> get getShoppingList => _shoppingList;
  set setShoppingList(value) {
    _shoppingList = value;
    notifyListeners();
  }

  void deleteById(ShoppingList) {
    _shoppingList.remove(ShoppingList);
    notifyListeners();
  }

  List<HistoryData> _historyData = [];
  List<HistoryData> get getHistoryData => _historyData;
  set setHistoryData(value) {
    _historyData = value;
    notifyListeners();
  }
}
