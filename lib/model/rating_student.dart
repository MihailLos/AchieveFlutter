class StudentRatingModel {
  String? data;
  String? firstName;
  String? format;
  String? groupName;
  String? instituteName;
  String? lastName;
  int? score;
  String? streamName;
  int? studentId;

  StudentRatingModel(
      {this.data,
        this.firstName,
        this.format,
        this.groupName,
        this.instituteName,
        this.lastName,
        this.score,
        this.streamName,
        this.studentId});

  StudentRatingModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    firstName = json['firstName'];
    format = json['format'];
    groupName = json['groupName'];
    instituteName = json['instituteName'];
    lastName = json['lastName'];
    score = json['score'];
    streamName = json['streamName'];
    studentId = json['studentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['firstName'] = this.firstName;
    data['format'] = this.format;
    data['groupName'] = this.groupName;
    data['instituteName'] = this.instituteName;
    data['lastName'] = this.lastName;
    data['score'] = this.score;
    data['streamName'] = this.streamName;
    data['studentId'] = this.studentId;
    return data;
  }
}