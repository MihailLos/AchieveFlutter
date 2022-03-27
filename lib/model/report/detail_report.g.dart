// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailReportModel _$DetailReportModelFromJson(Map<String, dynamic> json) =>
    DetailReportModel(
      comment: json['comment'] as String?,
      description: json['description'] as String?,
      errorId: json['errorId'] as int?,
      messageErrorDate: json['messageErrorDate'] as String?,
      statusErrorName: json['statusErrorName'] as String?,
      theme: json['theme'] as String?,
    );

Map<String, dynamic> _$DetailReportModelToJson(DetailReportModel instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'description': instance.description,
      'errorId': instance.errorId,
      'messageErrorDate': instance.messageErrorDate,
      'statusErrorName': instance.statusErrorName,
      'theme': instance.theme,
    };
