// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentProfileModel _$StudentProfileModelFromJson(Map<String, dynamic> json) =>
    StudentProfileModel(
      data: json['data'] as String?,
      firstName: json['firstName'] as String?,
      formEducationName: json['formEducationName'] as String?,
      format: json['format'] as String?,
      groupName: json['groupName'] as String?,
      instituteFullName: json['instituteFullName'] as String?,
      lastName: json['lastName'] as String?,
      score: json['score'] as int?,
      statusUser: json['statusUser'] as String?,
      streamFullName: json['streamFullName'] as String?,
    );

Map<String, dynamic> _$StudentProfileModelToJson(
        StudentProfileModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'firstName': instance.firstName,
      'formEducationName': instance.formEducationName,
      'format': instance.format,
      'groupName': instance.groupName,
      'instituteFullName': instance.instituteFullName,
      'lastName': instance.lastName,
      'score': instance.score,
      'statusUser': instance.statusUser,
      'streamFullName': instance.streamFullName,
    };
