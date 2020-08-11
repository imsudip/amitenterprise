import 'package:amitEnterprise/api/labourApi.dart';
import 'package:amitEnterprise/models/labour.dart';
import 'package:amitEnterprise/models/work.dart';
import 'package:amitEnterprise/notifier/labourNotifier.dart';
import 'package:amitEnterprise/notifier/workNotifier.dart';
import 'package:amitEnterprise/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddLabours extends StatefulWidget {
  AddLabours({Key key}) : super(key: key);

  @override
  _AddLaboursState createState() => _AddLaboursState();
}

class _AddLaboursState extends State<AddLabours> {
  List<ListItem> list = [];
  bool isediting = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  buildlist(LabourNotifier labourNotifier) {
    List<ListItem> list1 = [];
    if (list.isEmpty) {
      for (int i = 0; i < labourNotifier.labourList.length; i++) {
        list1.add(ListItem(labourNotifier.labourList[i].labourName));
      }
      list = list1;
    } else {
      for (int i = 0; i < list.length; i++) {
        list1.add(list[i]);
      }
      list = list1;
    }
  }

  onsave() {
    WorkNotifier workNotifier =
        Provider.of<WorkNotifier>(context, listen: false);
    List<LabourValue> labourList = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].isSelected) {
        labourList
            .add(LabourValue(labourName: list[i].data, wage: 0, isPaid: false));
      }
    }
    Work work = workNotifier.currentWork;
    work.labourValue = labourList;
    workNotifier.setCurrentWork = work;
    Navigator.of(context).pop();
  }

  onadd(String name) async {
    LabourNotifier labourNotifier =
        Provider.of<LabourNotifier>(context, listen: false);
    List<Labour> listT = [];
    listT.addAll(labourNotifier.labourList);
    Labour l =
        Labour(labourName: name, totalPaid: 0, totalWork: 0, workValue: []);
    listT.add(l);
    list.insert(0, ListItem(name));
    setState(() {});
    await addLabour(labourNotifier: labourNotifier, labour: l);
  }

  editRow() => Row(
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.navigate_before,
                color: Colors.redAccent,
                size: 40,
              ),
              onPressed: () {
                isediting = false;
                setState(() {});
              }),
          Expanded(
              child: TextField(
            controller: textEditingController,
            keyboardType: TextInputType.url,
          )),
          IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.lightGreen,
                size: 40,
              ),
              onPressed: () {
                onadd(textEditingController.text);
                isediting = false;
                setState(() {});
              })
        ],
      );
  @override
  Widget build(BuildContext context) {
    LabourNotifier labourNotifier = Provider.of<LabourNotifier>(context);
    buildlist(labourNotifier);
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(5.0),
              height: 60,
              child: isediting
                  ? editRow()
                  : Hero(
                      tag: "addLab",
                      child: FlatButton(
                          color: Colors.blue[500],
                          onPressed: () {
                            isediting = true;
                            setState(() {});
                          },
                          child: Center(
                            child: Text("+ ADD NEW LABOUR",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          )),
                    ),
            ),
            Expanded(
              child: Container(
                //height: MediaQuery.of(context).size.height - 220,
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          list[index].data,
                          style: listItemTitle,
                        ),
                        trailing: Checkbox(
                          value: list[index].isSelected,
                          onChanged: (newVal) {
                            setState(() {
                              list[index].isSelected = !list[index].isSelected;
                            });
                          },
                        ),
                      );
                    }),
              ),
            ),
            Container(
              height: 50,
              child: FlatButton(
                  color: CupertinoColors.activeGreen,
                  onPressed: () {
                    onsave();
                  },
                  child: Center(
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )),
            )
          ],
        ));
  }
}

class ListItem<String> {
  bool isSelected = false;
  String data;
  ListItem(this.data);
}
