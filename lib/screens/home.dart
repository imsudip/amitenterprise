import 'package:amitEnterprise/api/labourApi.dart';
import 'package:amitEnterprise/api/workapi.dart';
import 'package:amitEnterprise/models/work.dart';
import 'package:amitEnterprise/notifier/labourNotifier.dart';
import 'package:amitEnterprise/notifier/workNotifier.dart';
import 'package:amitEnterprise/screens/LabourViewUi.dart';
import 'package:amitEnterprise/screens/StatsviewUi.dart';
import 'package:amitEnterprise/screens/WorkViewUi.dart';
import 'package:amitEnterprise/screens/addLabourPage.dart';
import 'package:amitEnterprise/screens/addWork.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    LabourNotifier labourNotifier =
        Provider.of<LabourNotifier>(context, listen: false);
    getLabours(labourNotifier);

    super.initState();
  }

  TextStyle activeHeading =
      TextStyle(color: Colors.black, fontSize: 42, fontWeight: FontWeight.w500);
  TextStyle heading =
      TextStyle(color: Colors.grey, fontSize: 32, fontWeight: FontWeight.w500);
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "float",
        onPressed: () {
          selectedIndex == 0
              ? Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddWork()))
              : Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddNewLabour()));
        },
        label: Text(
          selectedIndex == 0 ? "Add work" : "Add labour",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        ),
        icon: Icon(CupertinoIcons.add),
      ),
      appBar: PreferredSize(
          child: Container(
            margin: EdgeInsets.only(top: 18),
            // height: 150,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      selectedIndex = 0;
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Works",
                        style: selectedIndex == 0 ? activeHeading : heading,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectedIndex = 1;
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Labours",
                        style: selectedIndex == 1 ? activeHeading : heading,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectedIndex = 2;
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Stats",
                        style: selectedIndex == 2 ? activeHeading : heading,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(100)),
      backgroundColor: Colors.blueGrey[50],
      body: selectedIndex == 0
          ? WorkViewUi()
          : selectedIndex == 1
              ? LabourViewUi()
              : StatsViewUi(),
      bottomNavigationBar: DotNavigationBar(
        currentIndex: selectedIndex,
        onTap: (i) {
          setState(() {
            selectedIndex = i;
          });
        },
        margin: EdgeInsets.zero,
        items: [
          /// Home
          DotNavigationBarItem(
            icon: selectedIndex == 0
                ? Icon(EvaIcons.briefcase)
                : Icon(EvaIcons.briefcaseOutline),
          ),

          /// Likes
          DotNavigationBarItem(
            icon: Icon(
                selectedIndex == 1 ? EvaIcons.people : EvaIcons.peopleOutline),
          ),

          /// Search
          DotNavigationBarItem(
            icon: Icon(selectedIndex == 2
                ? EvaIcons.activity
                : EvaIcons.activityOutline),
          ),
        ],
      ),
    );
  }
}
