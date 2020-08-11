class Work {
  String id;
  String title;
  String date;
  List<LabourValue> labourValue=[];

  Work({this.id, this.title, this.date, this.labourValue});

  Work.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    if (json['labourValue'] != null) {
      labourValue = new List<LabourValue>();
      json['labourValue'].forEach((v) {
        labourValue.add(new LabourValue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['date'] = this.date;
    if (this.labourValue != null) {
      data['labourValue'] = this.labourValue.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LabourValue {
  String labourName;
  int wage;
  bool isPaid;

  LabourValue({this.labourName, this.wage=0, this.isPaid=false});

  LabourValue.fromJson(Map<String, dynamic> json) {
    labourName = json['labourName'];
    wage = json['wage'];
    isPaid = json['isPaid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labourName'] = this.labourName;
    data['wage'] = this.wage;
    data['isPaid'] = this.isPaid;
    return data;
  }
}