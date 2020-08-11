import 'package:amitEnterprise/notifier/workNotifier.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time/time.dart';
import 'package:velocity_x/velocity_x.dart';

class StatsViewUi extends StatefulWidget {
  StatsViewUi({Key key}) : super(key: key);

  @override
  _StatsViewUiState createState() => _StatsViewUiState();
}

class _StatsViewUiState extends State<StatsViewUi> {
  String today = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
  String lastMon =
      formatDate(DateTime.now().subtract(30.days), [dd, '/', mm, '/', yyyy]);
  DateTime d1, d2 = DateTime.now();
  String d1String = "Pick Date";
  String d2String = "Pick Date";
  Stats stats;
  Widget _widget = Container();
  Stats calculateWorks(DateTime date1, DateTime date2) {
    Stats stats = Stats(
        worksDone: 0,
        totalCost: 0,
        totalPaid: 0,
        startDate: date1,
        endDate: date2);
    WorkNotifier workNotifier =
        Provider.of<WorkNotifier>(context, listen: false);
    for (var i = 0; i < workNotifier.workList.length; i++) {
      DateTime d = DateTime.parse(workNotifier.workList[i].date);
      if (d.isAfter(date2) && d.isBefore(date1)) {
        ++stats.worksDone;
        for (var j = 0; j < workNotifier.workList[i].labourValue.length; j++) {
          stats.totalCost += workNotifier.workList[i].labourValue[j].wage;
          if (workNotifier.workList[i].labourValue[j].isPaid)
            stats.totalPaid += workNotifier.workList[i].labourValue[j].wage;
        }
      }
    }
    return stats;
  }

  @override
  void initState() {
    stats = calculateWorks(DateTime.now(), DateTime.now().subtract(30.days));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: statCard(stats, "Last Month"),
        ),
        SliverToBoxAdapter(
          child: Card(
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton.icon(
                        color: Colors.orange[100],
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2010),
                                  lastDate: DateTime(2050))
                              .then((value) {
                            d1 = value;
                            d1String =
                                formatDate(value, [dd, '/', mm, '/', yyyy]);
                            setState(() {});
                          });
                        },
                        icon: Icon(Icons.calendar_today),
                        label: Text(d1String),
                      ),
                      Text("   To   "),
                      FlatButton.icon(
                        color: Colors.blue[100],
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2010),
                                  lastDate: DateTime(2050))
                              .then((value) {
                            d2 = value;
                            d2String =
                                formatDate(value, [dd, '/', mm, '/', yyyy]);
                            setState(() {});
                          });
                        },
                        icon: Icon(Icons.calendar_today),
                        label: Text(d2String),
                      )
                    ],
                  ),
                  FlatButton(
                      onPressed: () {
                        Stats st = calculateWorks(d2, d1);
                        _widget = statCard(st, "Statistics");
                        setState(() {});
                      },
                      shape: StadiumBorder(),
                      color: Colors.blue,
                      child: Text(
                        "Generate Stats",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _widget,
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 100,
          ),
        )
      ],
    );
  }

  Widget statCard(Stats stats, String title) {
    String s2 = formatDate(stats.startDate, [dd, '/', mm, '/', yyyy]);
    String s1 = formatDate(stats.endDate, [dd, '/', mm, '/', yyyy]);
    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(16)),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            HeightBox(8),
            Text(
              "($s1 - $s2)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
            HeightBox(8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Total Works: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(stats.worksDone.toString(),
                    style: TextStyle(fontSize: 22)),
              ],
            ),
            HeightBox(8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Total Cost: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("\u20B9" + stats.totalCost.toString(),
                    style: TextStyle(fontSize: 22, color: Colors.green)),
              ],
            ),
            HeightBox(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Paid:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("\u20B9" + stats.totalPaid.toString(),
                        style: TextStyle(fontSize: 22, color: Colors.green)),
                  ],
                ),
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "UnPaid:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "\u20B9" +
                            (stats.totalCost - stats.totalPaid).toString(),
                        style: TextStyle(fontSize: 22, color: Colors.red)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Stats {
  DateTime startDate;
  DateTime endDate;
  int worksDone;
  int totalCost;
  int totalPaid;
  Stats(
      {this.worksDone,
      this.totalCost,
      this.totalPaid,
      this.startDate,
      this.endDate});
}
