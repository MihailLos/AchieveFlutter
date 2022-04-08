class StudentProfileModel {
  String? data;
  String? firstName;
  String? formEducationName;
  String? format;
  String? groupName;
  String? instituteFullName;
  String? lastName;
  int? score;
  String? statusUser;
  String? streamFullName;

  StudentProfileModel(
      {this.data,
        this.firstName,
        this.formEducationName,
        this.format,
        this.groupName,
        this.instituteFullName,
        this.lastName,
        this.score,
        this.statusUser,
        this.streamFullName});

  StudentProfileModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'];
    firstName = json['firstName'];
    formEducationName = json['formEducationName'];
    format = json['format'];
    groupName = json['groupName'];
    instituteFullName = json['instituteFullName'];
    lastName = json['lastName'];
    score = json['score'];
    statusUser = json['statusUser'];
    streamFullName = json['streamFullName'];
  }
}
