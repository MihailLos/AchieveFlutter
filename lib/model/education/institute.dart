class InstituteModel {
  String? instituteFullName;
  int? instituteId;

  InstituteModel({this.instituteFullName, this.instituteId});

  InstituteModel.fromJson(Map<String, dynamic> json) {
    instituteFullName = json['instituteFullName'];
    instituteId = json['instituteId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['instituteFullName'] = this.instituteFullName;
    data['instituteId'] = this.instituteId;
    return data;
  }
}
