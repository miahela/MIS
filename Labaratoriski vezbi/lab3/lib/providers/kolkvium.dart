import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/kolokvium.dart';
import '../helpers/db_helper.dart';

class Kolokvium with ChangeNotifier {
  List<Kolokvium> _items = [];

  List<Kolokvium> get items {
    return [..._items];
  }

  void addKolkvium(String name, String date) {
    final newKolokvium = Kolokvium(
      name: name,
      date: date,
    );

    _items.add(newKolokvium);
    notifyListeners();
  }
}
