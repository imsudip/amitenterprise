import 'package:amitEnterprise/models/labour.dart';
import 'package:flutter/material.dart';

class LabourNotifier with ChangeNotifier {
  List<Labour> _labourList = [];

  List<Labour> get labourList => _labourList;

  set labourList(List<Labour> list) {
    _labourList = list;
    notifyListeners();
  }

  addLabour(Labour labour) {
    _labourList.insert(0, labour);
    notifyListeners();
  }

  deleteLabour(Labour labour) {
    _labourList
        .removeWhere((element) => element.labourName == labour.labourName);
    notifyListeners();
  }
}
