import 'package:amitEnterprise/api/workapi.dart';
import 'package:amitEnterprise/models/labour.dart';
import 'package:amitEnterprise/models/work.dart';
import 'package:amitEnterprise/notifier/labourNotifier.dart';
import 'package:amitEnterprise/notifier/workNotifier.dart';
import 'package:amitEnterprise/screens/addlabour.dart';
import 'package:amitEnterprise/style.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:velocity_x/velocity_x.dart';

class AddWork extends StatefulWidget {
  AddWork({Key key}) : super(key: key);

  @override
  _AddWorkState createState() => _AddWorkState();
}

class _AddWorkState extends State<AddWork> {
  Work work = Work(labourValue: []);
  int total = 0;
  TextEditingController _titleController = TextEditingController();
  PanelController _controller = PanelController();
  DateTime _dateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    WorkNotifier workNotifier =
        Provider.of<WorkNotifier>(context, listen: false);

    workNotifier.setCurrentWork =
        Work(labourValue: [], date: DateTime.now().toIso8601String());
  }

  calculateTotal() {
    for (int i = 0; i < work.labourValue.length; i++) {
      total = total + work.labourValue[i].wage;
    }
  }

  showDatePicker() => Hero(
        tag: "calender",
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _dateTime,
              onDateTimeChanged: (date) {
                work.date = date.toIso8601String();
                print(work.date);
                setState(() {});
              },
            ),
          ),
        ),
      );
  @override
  void dispose() {
    total = 0;
    super.dispose();
  }

  void onsave() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("saving your work..."),
            content: CupertinoActivityIndicator(),
          );
        });
    if (!_titleController.text.isEmptyOrNull) {
      WorkNotifier workNotifier =
          Provider.of<WorkNotifier>(context, listen: false);
      LabourNotifier labourNotifier =
          Provider.of<LabourNotifier>(context, listen: false);
      addWork(workNotifier, labourNotifier, work, () {
        print("added work");
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    WorkNotifier workNotifier = Provider.of<WorkNotifier>(context);
    work = workNotifier.currentWork;
    total = 0;
    calculateTotal();
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
          "Add Work",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: <Widget>[
            //HeightBox(15),
            CupertinoTextField(
              placeholder: "Add Title",
              controller: _titleController,
              clearButtonMode: OverlayVisibilityMode.editing,
              autofocus: false,
              focusNode: FocusNode(),
              maxLines: null,
              style: TextStyle(fontSize: 24),
              onChanged: (value) {
                work.title = value;
                print(value);
              },
            ),
            Container(
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                        child: Text(
                      work.date != null
                          ? formatDate(DateTime.parse(work.date),
                              [dd, '/', mm, '/', yyyy])
                          : "Pick a Date",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                    SizedBox(
                      width: 12,
                    ),
                    Hero(
                      tag: "calender",
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        child: IconButton(
                            color: Colors.blue,
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => showDatePicker());
                            }),
                      ),
                    ),
                  ],
                )),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Workers",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Rs. " + total.toString(),
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 26,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Container(
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                        child: Hero(
                      tag: "addLab",
                      child: CupertinoButton(
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(22),
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddLabours()));
                          },
                          child: Text("Add Labours")),
                    )),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        child: Hero(
                      tag: "addWage",
                      child: CupertinoButton(
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(22),
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddWage()));
                          },
                          child: Text("Set Wage")),
                    )),
                  ],
                )),
            Expanded(
              // flex: 4,
              child: Container(
                child: ListView.builder(
                    itemBuilder: (context, index) => Slidable(
                          actionExtentRatio: 0.2,
                          child: ListTile(
                            title: Text(
                              work.labourValue[index].labourName,
                              style: listItemTitle,
                            ),
                            trailing: Text(
                              "Rs. " + work.labourValue[index].wage.toString(),
                              style: listItemTitle.copyWith(
                                  color: work.labourValue[index].isPaid
                                      ? CupertinoColors.activeGreen
                                      : CupertinoColors.destructiveRed),
                            ),
                          ),
                          actionPane: SlidableDrawerActionPane(),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'edit',
                              foregroundColor: Colors.blueAccent,
                              //color: Colors.grey[100],
                              icon: Icons.edit,
                              onTap: () {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                          title: Text(work
                                              .labourValue[index].labourName),
                                          content: Card(
                                            color: Colors.transparent,
                                            elevation: 0,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "Enter New Wage"),
                                                      onChanged: (value) {
                                                        work.labourValue[index]
                                                                .wage =
                                                            int.parse(value);
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                            ),
                            IconSlideAction(
                              caption: 'Delete',
                              foregroundColor: Colors.red,
                              //color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                work.labourValue.removeAt(index);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                    itemCount: work != null ? work.labourValue.length : 0),
              ),
            ),
            Container(
              height: 50,
              child: Hero(
                tag: "float",
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddWage extends StatefulWidget {
  AddWage({Key key}) : super(key: key);

  @override
  _AddWageState createState() => _AddWageState();
}

class _AddWageState extends State<AddWage> {
  Work work;
  int counter = 0;
  String lastInput = "100";
  TextEditingController textEditingController = TextEditingController();
  onsave() {
    work.labourValue[counter].wage = int.parse(textEditingController.text);
    ++counter;
    lastInput = textEditingController.text;
    textEditingController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    WorkNotifier workNotifier = Provider.of<WorkNotifier>(context);
    work = workNotifier.currentWork;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Hero(
          tag: "addWage",
          child: Container(
            height: 300,
            width: 300,
            child: Card(
              elevation: 22,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: counter < work.labourValue.length
                    ? Column(
                        children: <Widget>[
                          Text(work.labourValue[counter].labourName,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500)),
                          HeightBox(20),
                          Center(
                            child: TextField(
                              autofocus: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              controller: textEditingController,
                              decoration: InputDecoration(
                                hintText: "WAGE",
                              ),
                              // onSubmitted: (wage) {
                              //   work.labourValue[counter].wage = int.parse(wage);
                              //   ++counter;
                              //   setState(() {});
                              // },
                              onEditingComplete: onsave,
                            ),
                          ),
                          HeightBox(20),
                          lastInput != ""
                              ? Container(
                                  height: 60,
                                  child: FlatButton(
                                    //color: CupertinoColors.activeGreen,
                                    onPressed: () {
                                      textEditingController.text = lastInput;
                                    },
                                    child: Card(
                                        color: CupertinoColors.activeGreen
                                            .withOpacity(0.2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(lastInput,
                                              style: TextStyle(
                                                  color: CupertinoColors
                                                      .activeGreen,
                                                  fontSize: 20)),
                                        )),
                                  ),
                                )
                              : Container(),
                          Container(
                            height: 60,
                            child: FlatButton(
                              color: CupertinoColors.activeGreen,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22)),
                              onPressed: onsave,
                              child: Center(
                                child: Text("save",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Container(
                          height: 60,
                          child: FlatButton(
                            color: CupertinoColors.activeGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22)),
                            onPressed: () {
                              workNotifier.setCurrentWork = work;
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text("done",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
