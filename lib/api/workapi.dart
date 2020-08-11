import 'package:amitEnterprise/api/labourApi.dart';
import 'package:amitEnterprise/models/labour.dart';
import 'package:amitEnterprise/models/work.dart';
import 'package:amitEnterprise/notifier/labourNotifier.dart';
import 'package:amitEnterprise/notifier/workNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

addWork(WorkNotifier workNotifier, LabourNotifier labourNotifier, Work work,
    VoidCallback onDone) async {
  CollectionReference workRef = Firestore.instance.collection('works');
  CollectionReference labourRef = Firestore.instance.collection('labours');
  DocumentReference docRef = await workRef.add(work.toJson());
  work.id = docRef.documentID;
  await workRef.document(work.id).setData(work.toJson(), merge: true);
  for (int i = 0; i < work.labourValue.length; i++) {
    Labour labour = getLabour(labourNotifier, work.labourValue[i].labourName);
    labour.workValue.add(WorkValue(
        workId: work.id,
        wage: work.labourValue[i].wage,
        isPaid: work.labourValue[i].isPaid));
    await labourRef
        .document(work.labourValue[i].labourName)
        .setData(labour.toJson(), merge: true);
  }
  workNotifier.addWork(work);
  onDone();
}

deleteWork(WorkNotifier workNotifier, LabourNotifier labourNotifier, Work work,
    VoidCallback onDone) async {
  CollectionReference workRef = Firestore.instance.collection('works');
  CollectionReference labourRef = Firestore.instance.collection('labours');
  await workRef.document(work.id).delete();
  for (var i = 0; i < work.labourValue.length; i++) {
    Labour labour = getLabour(labourNotifier, work.labourValue[i].labourName);
    labour.workValue.removeWhere((element) => element.workId == work.id);
    await labourRef
        .document(work.labourValue[i].labourName)
        .setData(labour.toJson(), merge: false);
  }
  workNotifier.deleteWork(work);
  onDone();
}

Future<void> getWorks(WorkNotifier workNotifier) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection('works').getDocuments();

  List<Work> _workList = [];
  snapshot.documents.forEach((element) {
    Work work = Work.fromJson(element.data);
    _workList.add(work);
  });

  _workList.sort((a, b) {
    DateTime d1 = DateTime.parse(a.date);
    DateTime d2 = DateTime.parse(b.date);
    return d2.compareTo(d1);
  });

  workNotifier.workList = _workList;
}

Work getWork(WorkNotifier workNotifier, String id) {
  Work work = workNotifier.workList.firstWhere((element) => element.id == id);
  return work;
}
