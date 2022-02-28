import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

class ReportsCollectionModel {
  List<ReportModel> list;

  ReportsCollectionModel(this.list);

  factory ReportsCollectionModel.fromJson(List<dynamic> json) => ReportsCollectionModel(json.map((e) => ReportModel.fromJson(e)).toList());
}

@JsonSerializable()
class ReportModel {
  String? messageErrorDate;
  String? statusErrorName;
  String? theme;
  int? errorId;

  ReportModel(
      {this.messageErrorDate, this.statusErrorName, this.theme, this.errorId});

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}
