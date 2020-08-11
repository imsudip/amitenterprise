class Labour  {
  String labourName;
  int totalPaid;
  int totalWork;
  List<WorkValue> workValue=[];

  Labour({this.labourName, this.totalPaid=0, this.totalWork=0, this.workValue});

  Labour.fromJson(Map<String, dynamic> json) {
    labourName = json['labourName'];
    totalPaid = json['totalPaid'];
    totalWork = json['totalWork'];
    if (json['workValue'] != null) {
      workValue = new List<WorkValue>();
      json['workValue'].forEach((v) {
        workValue.add(new WorkValue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labourName'] = this.labourName;
    data['totalPaid'] = this.totalPaid;
    data['totalWork'] = this.totalWork;
    if (this.workValue != null) {
      data['workValue'] = this.workValue.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkValue {
  String workId;
  int wage;
  bool isPaid;

  WorkValue({this.workId, this.wage, this.isPaid});

  WorkValue.fromJson(Map<String, dynamic> json) {
    workId = json['workId'];
    wage = json['wage'];
    isPaid = json['isPaid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workId'] = this.workId;
    data['wage'] = this.wage;
    data['isPaid'] = this.isPaid;
    return data;
  }
}