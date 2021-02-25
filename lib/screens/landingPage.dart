import 'package:amitEnterprise/screens/LabourViewUi.dart';
import 'package:amitEnterprise/screens/StatsviewUi.dart';
import 'package:amitEnterprise/screens/WorkViewUi.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';

import 'package:dot_navigation_bar/dot_navigation_bar.dart';

import '../style.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  int selectedTab = 0;
  List<Widget> screens = [WorkViewUi(), LabourViewUi(), StatsViewUi()];
  List<String> tabs = ['Contracts', 'Labours', 'Insights'];
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        new TabController(length: 3, vsync: this, initialIndex: selectedTab);
    _controller.addListener(_handleSelected);
  }

  void _handleSelected() {
    setState(() {
      selectedTab = _controller.index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        title: Text(
          tabs[selectedTab],
          style: pageTitle.copyWith(color: blueDark),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: TabBarView(
                controller: _controller,
                children: List.generate(3, (index) => screens[index])),
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _bottomAppBar())
        ],
      ),
    );
  }

  Container _bottomAppBar() {
    return Container(
      height: kBottomNavigationBarHeight + 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: grey,
          child: Center(
            child: DotNavigationBar(
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 5),
              itemPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              currentIndex: selectedTab,
              onTap: (i) {
                setState(() {
                  _controller.animateTo(i,
                      duration: Duration(milliseconds: 400));
                });
              },
              unselectedItemColor: greyLight,
              // dotIndicatorColor: Colors.black,
              items: [
                /// Home
                DotNavigationBarItem(
                  icon: selectedTab == 0
                      ? Icon(EvaIcons.briefcase)
                      : Icon(EvaIcons.briefcaseOutline),
                  selectedColor: blue,
                ),
                DotNavigationBarItem(
                  icon: selectedTab == 1
                      ? Icon(EvaIcons.grid)
                      : Icon(EvaIcons.gridOutline),
                  selectedColor: blue,
                ),
                DotNavigationBarItem(
                  icon: selectedTab == 2
                      ? Icon(EvaIcons.heart)
                      : Icon(EvaIcons.heartOutline),
                  selectedColor: blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
