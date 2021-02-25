import 'package:amitEnterprise/api/workapi.dart';
import 'package:amitEnterprise/models/work.dart';
import 'package:amitEnterprise/notifier/workNotifier.dart';
import 'package:amitEnterprise/screens/WorkDetail.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkViewUi extends StatefulWidget {
  WorkViewUi({Key key}) : super(key: key);

  @override
  _WorkViewUiState createState() => _WorkViewUiState();
}

class _WorkViewUiState extends State<WorkViewUi> {
  @override
  void initState() {
    WorkNotifier workNotifier =
        Provider.of<WorkNotifier>(context, listen: false);
    getWorks(workNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WorkNotifier workNotifier = Provider.of<WorkNotifier>(context);
    return CustomScrollView(
      slivers: <Widget>[
        workNotifier.workList.isNotEmpty
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => Hero(
                          tag: "workName$index",
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => WorkDetail(
                                          work: workNotifier.workList[index],
                                          i: index,
                                        )));
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Text(
                                                workNotifier
                                                    .workList[index].title,
                                                maxLines: 4,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                              formatDate(
                                                  DateTime.parse(workNotifier
                                                      .workList[index].date),
                                                  [dd, '/', mm, '/', yyyy]),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300)),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "\u20B9" +
                                          calculateTotalCost(
                                            workNotifier.workList[index],
                                          ).toString(),
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    childCount: workNotifier.workList.length))
            : SliverToBoxAdapter(
                child: Center(
                  child: Card(
                      child: Container(
                          height: 50,
                          width: 50,
                          child: CupertinoActivityIndicator())),
                ),
              ),
      ],
    );
  }
}

int calculateTotalCost(Work work) {
  int sum = 0;
  for (int i = 0; i < work.labourValue.length; i++) {
    sum += work.labourValue[i].wage;
  }
  return sum;
}
