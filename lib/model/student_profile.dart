import 'package:json_annotation/json_annotation.dart';

part 'student_profile.g.dart';

@JsonSerializable()
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

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) => _$StudentProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$StudentProfileModelToJson(this);
}
