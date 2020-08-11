import 'package:amitEnterprise/models/work.dart';
import 'package:flutter/material.dart';

class WorkNotifier with ChangeNotifier {
  List<Work> _workList = [];
  Work currentWork;

  List<Work> get workList => _workList;

  set workList(List<Work> list) {
    _workList = list;
    notifyListeners();
  }

  set setCurrentWork(Work w) {
    currentWork = w;
    notifyListeners();
  }

  addWork(Work work) {
    _workList.insert(0, work);
    notifyListeners();
  }

  deleteWork(Work work) {
    _workList.removeWhere((element) => element.id == work.id);
    notifyListeners();
  }
}
