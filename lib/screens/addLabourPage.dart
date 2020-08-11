import 'package:amitEnterprise/api/labourApi.dart';
import 'package:amitEnterprise/models/labour.dart';
import 'package:amitEnterprise/notifier/labourNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewLabour extends StatefulWidget {
  AddNewLabour({Key key}) : super(key: key);

  @override
  _AddNewLabourState createState() => _AddNewLabourState();
}

class _AddNewLabourState extends State<AddNewLabour> {
  TextEditingController controller = TextEditingController(text: "");
  onadd() async {
    if (controller.text.isEmpty) return;
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Adding new labour..."),
            content: CupertinoActivityIndicator(),
          );
        });
    LabourNotifier labourNotifier =
        Provider.of<LabourNotifier>(context, listen: false);
    List<Labour> listT = [];
    listT.addAll(labourNotifier.labourList);
    Labour l = Labour(
        labourName: controller.text, totalPaid: 0, totalWork: 0, workValue: []);
    listT.add(l);
    await addLabour(labourNotifier: labourNotifier, labour: l);
    Navigator.of(context).pop();
    controller.text = "";
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Labour Added Successfully"),
            //content: CupertinoActivityIndicator(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Hero(
          tag: "float",
          child: Container(
            height: 300,
            width: 300,
            child: Card(
                elevation: 22,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Add new Labour",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          autofocus: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                          keyboardType: TextInputType.text,
                          maxLines: 1,

                          controller: controller,
                          decoration: InputDecoration(
                            hintText: "ENTER NEW NAME",
                          ),
                          // onSubmitted: (wage) {
                          //   work.labourValue[counter].wage = int.parse(wage);
                          //   ++counter;
                          //   setState(() {});
                          // },
                          onEditingComplete: onadd,
                        ),
                      ),
                      Container(
                        height: 60,
                        child: FlatButton(
                          color: CupertinoColors.activeGreen,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22)),
                          onPressed: onadd,
                          child: Center(
                            child: Text("save",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
