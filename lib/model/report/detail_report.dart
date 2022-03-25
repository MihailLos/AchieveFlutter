import 'package:json_annotation/json_annotation.dart';

part 'detail_report.g.dart';

@JsonSerializable()
class DetailReportModel {
  String? comment;
  String? description;
  int? errorId;
  String? messageErrorDate;
  String? statusErrorName;
  String? theme;

  DetailReportModel({this.comment, this.description, this.errorId, this.messageErrorDate, this.statusErrorName, this.theme});

  factory DetailReportModel.fromJson(Map<String, dynamic> json) => _$DetailReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailReportModelToJson(this);
}