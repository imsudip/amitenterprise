import 'package:amitEnterprise/api/workapi.dart';
import 'package:amitEnterprise/models/labour.dart';
import 'package:amitEnterprise/models/work.dart';
import 'package:amitEnterprise/notifier/labourNotifier.dart';
import 'package:amitEnterprise/notifier/workNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

addLabour(
    {LabourNotifier labourNotifier, Labour labour, VoidCallback onDone}) async {
  CollectionReference labourRef = Firestore.instance.collection('labours');
  await labourRef.document(labour.labourName).setData(labour.toJson());
  labourNotifier.addLabour(labour);
}

getLabours(LabourNotifier labourNotifier) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection('labours').getDocuments();

  List<Labour> _labourList = [];
  snapshot.documents.forEach((element) {
    Labour labour = Labour.fromJson(element.data);
    _labourList.add(labour);
  });
  _labourList.sort((a, b) {
    return a.labourName.toLowerCase().compareTo(b.labourName.toLowerCase());
  });
  labourNotifier.labourList = _labourList;
}

Labour getLabour(LabourNotifier labourNotifier, String labourName) {
  Labour labour = labourNotifier.labourList
      .firstWhere((element) => element.labourName == labourName);
  return labour;
}

payLabourThroughWork(WorkNotifier workNotifier, LabourNotifier labourNotifier,
    Work work, VoidCallback onDone) async {
  CollectionReference workRef = Firestore.instance.collection('works');
  CollectionReference labourRef = Firestore.instance.collection('labours');
  await workRef.document(work.id).setData(work.toJson());
  for (var i = 0; i < work.labourValue.length; i++) {
    if (work.labourValue[i].isPaid) {
      Labour labour = getLabour(labourNotifier, work.labourValue[i].labourName);
      for (var item in labour.workValue) {
        if (item.workId == work.id) item.isPaid = true;
      }
      labourRef.document(labour.labourName).setData(labour.toJson());
    }
  }
  getLabours(labourNotifier);
  getWorks(workNotifier);
  onDone();
}

payLabourThroughLabour(WorkNotifier workNotifier, LabourNotifier labourNotifier,
    Labour labour, VoidCallback onDone) async {
  CollectionReference workRef = Firestore.instance.collection('works');
  CollectionReference labourRef = Firestore.instance.collection('labours');
  await labourRef.document(labour.labourName).setData(labour.toJson());
  for (var i = 0; i < labour.workValue.length; i++) {
    if (labour.workValue[i].isPaid) {
      Work work = getWork(workNotifier, labour.workValue[i].workId);
      for (var item in work.labourValue) {
        if (item.labourName == labour.labourName) item.isPaid = true;
      }
      await workRef.document(work.id).setData(work.toJson());
    }
  }
  getLabours(labourNotifier);
  getWorks(workNotifier);
  onDone();
}
