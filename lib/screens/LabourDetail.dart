import 'package:amitEnterprise/api/labourApi.dart';
import 'package:amitEnterprise/api/workapi.dart';
import 'package:amitEnterprise/models/labour.dart';
import 'package:amitEnterprise/notifier/labourNotifier.dart';
import 'package:amitEnterprise/notifier/workNotifier.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LabourDetail extends StatefulWidget {
  final Labour labour;
  final int i;
  LabourDetail({Key key, this.labour, this.i}) : super(key: key);

  @override
  _LabourDetailState createState() => _LabourDetailState();
}

class _LabourDetailState extends State<LabourDetail> {
  List<WorkValue> workValue = [];
  List<bool> store = [];
  //int payableAmount = 0;
  @override
  void initState() {
    workValue = widget.labour.workValue;
    for (var i = 0; i < workValue.length; i++) {
      store.add(false);
    }
    super.initState();
  }

  int calculatePayAmount() {
    int payableAmount = 0;
    Labour labour = widget.labour;
    for (var i = 0; i < store.length; i++) {
      if (store[i] == true) {
        payableAmount += labour.workValue[i].wage;
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
    Labour labour = widget.labour;
    for (var i = 0; i < labour.workValue.length; i++) {
      if (store[i] == true) {
        labour.workValue[i].isPaid = true;
        workValue[i].isPaid = true;
      }
    }
    WorkNotifier workNotifier =
        Provider.of<WorkNotifier>(context, listen: false);
    LabourNotifier labourNotifier =
        Provider.of<LabourNotifier>(context, listen: false);
    payLabourThroughLabour(workNotifier, labourNotifier, labour, () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    WorkNotifier workNotifier =
        Provider.of<WorkNotifier>(context, listen: false);
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
        title: Text(
          "Labour Detail",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Hero(
        tag: "labourName${widget.i}",
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Name: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.labour.labourName,
                      style: TextStyle(fontSize: 20),
                      maxLines: 4,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Total works:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.labour.workValue.length.toString(),
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Total cost: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("\u20B9" + calculateTotalCost(workValue).toString(),
                        style: TextStyle(fontSize: 22, color: Colors.green)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Total Due: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("\u20B9" + calculateUnpaidCost(workValue).toString(),
                        style: TextStyle(fontSize: 22, color: Colors.red)),
                  ],
                ),
                Text(
                  "Works",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (context, index) => Card(
                                  color: workValue[index].isPaid
                                      ? Colors.blueGrey[200]
                                      : Colors.white,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
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
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                // width: 200,
                                                child: Text(
                                                  getWork(
                                                          workNotifier,
                                                          workValue[index]
                                                              .workId)
                                                      .title,
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
                                                formatDate(
                                                    DateTime.parse(getWork(
                                                            workNotifier,
                                                            workValue[index]
                                                                .workId)
                                                        .date),
                                                    [dd, '/', mm, '/', yyyy]),
                                                //maxLines: 4,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                  workValue[index].isPaid
                                                      ? "PAID"
                                                      : "UNPAID",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: workValue[index]
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
                                              workValue[index].wage.toString(),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 18),
                                        ),
                                        workValue[index].isPaid
                                            ? Container()
                                            : Checkbox(
                                                value: store[index],
                                                onChanged: (val) {
                                                  store[index] = !store[index];
                                                  setState(() {});
                                                })
                                      ],
                                    ),
                                  ),
                                ),
                            childCount: workValue.length)),
                  ],
                ))
              ],
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

int calculateTotalCost(List<WorkValue> workValue) {
  int sum = 0;
  for (var i = 0; i < workValue.length; i++) {
    sum += workValue[i].wage;
  }
  return sum;
}

int calculateUnpaidCost(List<WorkValue> workValue) {
  int sum = 0;
  for (var i = 0; i < workValue.length; i++) {
    if (workValue[i].isPaid == false) sum += workValue[i].wage;
  }
  return sum;
}

bool checkPayable(List<bool> store) {
  for (var i = 0; i < store.length; i++) {
    if (store[i]) return true;
  }
  return false;
}
