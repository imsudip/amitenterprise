import 'package:amitEnterprise/api/labourApi.dart';
import 'package:amitEnterprise/api/workapi.dart';
import 'package:amitEnterprise/models/work.dart';
import 'package:amitEnterprise/notifier/labourNotifier.dart';
import 'package:amitEnterprise/notifier/workNotifier.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkDetail extends StatefulWidget {
  final Work work;
  final int i;
  WorkDetail({Key key, this.work, this.i}) : super(key: key);

  @override
  _WorkDetailState createState() => _WorkDetailState();
}

class _WorkDetailState extends State<WorkDetail> {
  List<LabourValue> labourValue = [];
  List<bool> store = [];
  @override
  void initState() {
    labourValue = widget.work.labourValue;
    for (var i = 0; i < labourValue.length; i++) {
      store.add(false);
    }
    super.initState();
  }

  int calculatePayAmount() {
    int payableAmount = 0;
    Work work = widget.work;
    for (var i = 0; i < store.length; i++) {
      if (store[i] == true) {
        payableAmount += work.labourValue[i].wage;
      }
    }
    return payableAmount;
  }

  void onPay() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("saving your work..."),
            content: CupertinoActivityIndicator(),
          );
        });
    Work work = widget.work;
    for (var i = 0; i < work.labourValue.length; i++) {
      if (store[i] == true) {
        work.labourValue[i].isPaid = true;
        labourValue[i].isPaid = true;
      }
    }
    WorkNotifier workNotifier =
        Provider.of<WorkNotifier>(context, listen: false);
    LabourNotifier labourNotifier =
        Provider.of<LabourNotifier>(context, listen: false);
    payLabourThroughWork(workNotifier, labourNotifier, work, () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  onDelete() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Deleting this work..."),
            content: CupertinoActivityIndicator(),
          );
        });
    Work work = widget.work;

    WorkNotifier workNotifier =
        Provider.of<WorkNotifier>(context, listen: false);
    LabourNotifier labourNotifier =
        Provider.of<LabourNotifier>(context, listen: false);
    deleteWork(workNotifier, labourNotifier, work, () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text("Do you want to permanently delete it?"),
                        // content: CupertinoActivityIndicator(),
                        actions: <Widget>[
                          CupertinoButton(
                              child: Text("Yes"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                onDelete();
                              }),
                          CupertinoButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ],
                      );
                    });
                //onDelete();
              }),
        ],
        title: Text(
          "Work Detail",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Hero(
          tag: "workName${widget.i}",
          child: Card(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Title: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            widget.work.title,
                            maxLines: 4,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Date: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          formatDate(DateTime.parse(widget.work.date),
                              [dd, '/', mm, '/', yyyy]),
                          style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Total cost: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "\u20B9" + calculateTotalCost(labourValue).toString(),
                          style: TextStyle(fontSize: 22, color: Colors.green)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Total Due: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "\u20B9" +
                              calculateUnpaidCost(labourValue).toString(),
                          style: TextStyle(fontSize: 22, color: Colors.red)),
                    ],
                  ),
                  Text(
                    "Workers",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (context, index) => Card(
                                    color: labourValue[index].isPaid
                                        ? Colors.blueGrey[200]
                                        : Colors.white,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  // width: 200,
                                                  child: Text(
                                                    labourValue[index]
                                                        .labourName,
                                                    maxLines: 4,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                    labourValue[index].isPaid
                                                        ? "PAID"
                                                        : "UNPAID",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            labourValue[index]
                                                                    .isPaid
                                                                ? Colors.green
                                                                : Colors.red,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          Text(
                                            "\u20B9" +
                                                labourValue[index]
                                                    .wage
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 18),
                                          ),
                                          labourValue[index].isPaid
                                              ? Container()
                                              : Checkbox(
                                                  value: store[index],
                                                  onChanged: (val) {
                                                    store[index] =
                                                        !store[index];
                                                    setState(() {});
                                                  })
                                        ],
                                      ),
                                    ),
                                  ),
                              childCount: labourValue.length)),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: checkPayable(store)
          ? PreferredSize(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                padding: EdgeInsets.all(6),
                child: InkWell(
                  onTap: () {
                    onPay();
                  },
                  child: Card(
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        "PAY " + "\u20B9" + calculatePayAmount().toString(),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.1))
          : null,
    );
  }
}

int calculateTotalCost(List<LabourValue> labourValue) {
  int sum = 0;
  for (var i = 0; i < labourValue.length; i++) {
    sum += labourValue[i].wage;
  }
  return sum;
}

int calculateUnpaidCost(List<LabourValue> labourValue) {
  int sum = 0;
  for (var i = 0; i < labourValue.length; i++) {
    if (labourValue[i].isPaid == false) sum += labourValue[i].wage;
  }
  return sum;
}

bool checkPayable(List<bool> store) {
  for (var i = 0; i < store.length; i++) {
    if (store[i]) return true;
  }
  return false;
}
