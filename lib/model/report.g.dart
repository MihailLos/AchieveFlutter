// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
      messageErrorDate: json['messageErrorDate'] as String?,
      statusErrorName: json['statusErrorName'] as String?,
      theme: json['theme'] as String?,
      errorId: json['errorId'] as int?,
    );

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'messageErrorDate': instance.messageErrorDate,
      'statusErrorName': instance.statusErrorName,
      'theme': instance.theme,
      'errorId': instance.errorId,
    };
