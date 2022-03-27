import 'package:achieve_student_flutter/model/achievement/unreceived_achievement/unreceived_achievement.dart';
import 'package:achieve_student_flutter/model/education/group.dart';
import 'package:achieve_student_flutter/model/education/institute.dart';
import 'package:achieve_student_flutter/model/education/stream.dart';
import 'package:achieve_student_flutter/model/proof_achievement/proof_achieve.dart';
import 'package:achieve_student_flutter/model/student/rating_student.dart';

import '../model/achievement/achieve_category.dart';
import '../model/achievement/created_achievement/created_achievement.dart';
import '../model/achievement/received_achievement/received_achievement.dart';
import '../model/reward/reward.dart';

class Parser {
  List<AchieveCategoryModel> parseAchieveCategory(List response) {
    return response
        .map<AchieveCategoryModel>(
            (json) => AchieveCategoryModel.fromJson(json))
        .toList();
  }

  List<RewardModel> parseRewards(List response) {
    return response
        .map<RewardModel>(
            (json) => RewardModel.fromJson(json))
        .toList();
  }

  List<CreatedAchievementModel> parseCreatedProfileAchievements(List response) {
    return response
        .map<CreatedAchievementModel>(
            (json) => CreatedAchievementModel.fromJson(json))
        .toList();
  }

  List<ReceivedAchievementModel> parseReceivedProfileAchievements(
      List response) {
    return response
        .map<ReceivedAchievementModel>(
            (json) => ReceivedAchievementModel.fromJson(json))
        .toList();
  }

  List<CreatedAchievementModel> parseCreatedAchievements(List response) {
    return response
        .map<CreatedAchievementModel>(
            (json) => CreatedAchievementModel.fromJson(json))
        .toList();
  }

  List<ProofAchieveModel> parseProofAchievements(List response) {
    return response
        .map<ProofAchieveModel>(
            (json) => ProofAchieveModel.fromJson(json)).toList();
  }

  List<UnreceivedAchievementModel> parseUnreceivedAchievements(
      List response) {
    return response
        .map<UnreceivedAchievementModel>(
            (json) => UnreceivedAchievementModel.fromJson(json))
        .toList();
  }

  List<StudentRatingModel> parseStudents(List response) {
    return response
        .map<StudentRatingModel>((json) => StudentRatingModel.fromJson(json))
        .toList();
  }

  List<InstituteModel> parseInstitutes(List response) {
    return response
        .map<InstituteModel>((json) => InstituteModel.fromJson(json))
        .toList();
  }

  List<StreamModel> parseStreams(List response) {
    return response
        .map<StreamModel>((json) => StreamModel.fromJson(json))
        .toList();
  }

  List<GroupModel> parseGroups(List response) {
    return response
        .map<GroupModel>((json) => GroupModel.fromJson(json))
        .toList();
  }
}