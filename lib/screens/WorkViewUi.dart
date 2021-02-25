import 'package:amitEnterprise/api/workapi.dart';
import 'package:amitEnterprise/models/work.dart';
import 'package:amitEnterprise/notifier/workNotifier.dart';
import 'package:amitEnterprise/screens/WorkDetail.dart';
import 'package:amitEnterprise/style.dart';
import 'package:date_format/date_format.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
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
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: IconsOutlineButton(
              onPressed: () {
                setState(() {});
              },
              color: blueDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: blueDark, width: 3)),
              padding: EdgeInsets.symmetric(vertical: 8),
              text: 'New work ',
              iconData: EvaIcons.plusCircleOutline,
              textStyle: button.copyWith(color: blueDark),
              iconColor: blueDark,
            ),
          ),
        ),
        workNotifier.workList.isNotEmpty
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => Hero(
                          tag: "workName$index",
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => WorkDetail(
                                          work: workNotifier.workList[index],
                                          i: index,
                                        )));
                              },
                              child: CardWidget(
                                workNotifier: workNotifier,
                                index: index,
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

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key key,
    @required this.workNotifier,
    this.index,
  }) : super(key: key);

  final WorkNotifier workNotifier;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  // width: 200,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      workNotifier.workList[index].title,
                      maxLines: 2,
                      style: subtitle1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    Icon(
                      EvaIcons.pinOutline,
                      size: 16,
                    ),
                    Text(' location', style: bodytext2.copyWith(color: black)),
                  ],
                ),
                Text(
                    formatDate(
                        DateTime.parse(workNotifier.workList[index].date),
                        [dd, '/', mm, '/', yyyy]),
                    style: bodytext2.copyWith(color: grey)),
              ],
            ),
          ),
          Text(
            "  \u20B9 " +
                calculateTotalCost(
                  workNotifier.workList[index],
                ).toString(),
            style: money,
          )
        ],
      ),
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
