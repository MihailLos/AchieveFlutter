import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:achieve_student_flutter/model/group.dart';
import 'package:achieve_student_flutter/model/institute.dart';
import 'package:achieve_student_flutter/model/rating_student.dart';
import 'package:achieve_student_flutter/model/stream.dart';
import 'package:achieve_student_flutter/network_handler.dart';
import 'package:achieve_student_flutter/screens/rating/detail_student_screen.dart';
import 'package:achieve_student_flutter/screens/rating/rating_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

class RatingViewModel extends BaseViewModel {
  RatingViewModel(BuildContext context);

  List<StudentRatingModel> filteredStudents = [];
  List<StudentRatingModel> fetchedStudents = [];
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController searchController = TextEditingController();
  List<InstituteModel> institutesList = [];
  List<StreamModel> streamsList = [];
  List<GroupModel> groupsList = [];
  InstituteModel? filterInstitute;
  StreamModel? filterStream;
  GroupModel? filterGroup;
  FlutterSecureStorage storage = FlutterSecureStorage();
  bool isVisibleFilters = false;

  Future onReady() async {
    fetchStudentsTop10();
    fetchInstitutes();
  }

  Future<void> searchAction() async {
    filteredStudents = fetchedStudents
        .where((element) {
      return element.lastName!
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
    })
        .toList();
    notifyListeners();
  }

  void fetchStudentsTop10() async {
    var response = await networkHandler.get("/student/students10");
    fetchedStudents = parseStudents(response);
    filteredStudents = fetchedStudents;
    notifyListeners();
  }

  void fetchStudentsTop50() async {
    var response = await networkHandler.get("/student/students50");
    fetchedStudents = parseStudents(response);
    filteredStudents = fetchedStudents;
    notifyListeners();
  }

  void fetchStudentsTop100() async {
    var response = await networkHandler.get("/student/students100");
    fetchedStudents = parseStudents(response);
    filteredStudents = fetchedStudents;
    notifyListeners();
  }

  Uint8List getStudentImage(String base64String) {
    var firstDecode = base64Decode(base64String);
    String secondDecode = latin1.decode(firstDecode).replaceAll("\n", "");
    var decodedImage = base64Decode(secondDecode);
    return decodedImage;
  }

  void fetchInstitutes() async {
    var response = await networkHandler.get("/education/institutions");
    institutesList = parseInstitutes(response);
    notifyListeners();
  }

  void fetchStreams() async {
    var response = await networkHandler
        .get("/education/stream/${filterInstitute!.instituteId}");
    streamsList = parseStreams(response);
    notifyListeners();
  }

  void fetchGroups() async {
    var response =
        await networkHandler.get("/education/group/${filterStream!.streamId}");
    groupsList = parseGroups(response);
    notifyListeners();
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

  goToStudentDetail(context) {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => DetailStudentScreen()));
  }

  changeVisibility(context) {
    isVisibleFilters = !isVisibleFilters;
    notifyListeners();
  }

  onChangeInstituteFilter(InstituteModel? instituteModel) {
    filterStream = null;
    filterGroup = null;
    filterInstitute = instituteModel;
    fetchStreams();
    filteredStudents = fetchedStudents.where((element) => element.instituteName!
        .contains(instituteModel!.instituteFullName.toString())).toList();
    notifyListeners();
  }

  onChangeStreamFilter(StreamModel? streamModel) {
    filterGroup = null;
    filterStream = streamModel;
    fetchGroups();
    filteredStudents = fetchedStudents.where((element) => element.streamName!
        .contains(streamModel!.streamName.toString())).toList();
    notifyListeners();
  }

  onChangeGroupFilter(GroupModel? groupModel) {
    filterGroup = groupModel;
    filteredStudents = fetchedStudents.where((element) => element.groupName!
        .contains(groupModel!.groupName.toString())).toList();
    notifyListeners();
  }

  onTapStudent(context, String studentId) async {
    await storage.write(key: "student_id", value: studentId);
    notifyListeners();
    goToStudentDetail(context);
  }
}
