import 'package:amitEnterprise/api/labourApi.dart';
import 'package:amitEnterprise/models/labour.dart';
import 'package:amitEnterprise/notifier/labourNotifier.dart';
import 'package:amitEnterprise/screens/LabourDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LabourViewUi extends StatefulWidget {
  LabourViewUi({Key key}) : super(key: key);

  @override
  _LabourViewUiState createState() => _LabourViewUiState();
}

class _LabourViewUiState extends State<LabourViewUi> {
  @override
  void initState() {
    LabourNotifier labourNotifier =
        Provider.of<LabourNotifier>(context, listen: false);
    getLabours(labourNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LabourNotifier labourNotifier = Provider.of<LabourNotifier>(context);
    return CustomScrollView(
      slivers: <Widget>[
        labourNotifier.labourList.isNotEmpty
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LabourDetail(
                                      labour: labourNotifier.labourList[index],
                                      i: index,
                                    )));
                          },
                          child: Hero(
                            tag: "labourName$index",
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          labourNotifier
                                              .labourList[index].labourName,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                            "Total works: " +
                                                labourNotifier.labourList[index]
                                                    .workValue.length
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300)),
                                      ],
                                    ),
                                    Text(
                                      "Unpaid \u20B9" +
                                          calculateUnpaidCost(
                                            labourNotifier.labourList[index],
                                          ).toString(),
                                      style: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                          fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    childCount: labourNotifier.labourList.length))
            : SliverToBoxAdapter(
                child: Center(
                  child: Card(child: CupertinoActivityIndicator()),
                ),
              ),
      ],
    );
  }
}

int calculateUnpaidCost(Labour labour) {
  int sum = 0;
  for (int i = 0; i < labour.workValue.length; i++) {
    if (labour.workValue[i].isPaid == false) {
      sum += labour.workValue[i].wage;
    }
  }
  return sum;
}
