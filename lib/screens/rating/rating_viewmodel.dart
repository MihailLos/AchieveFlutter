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

  topStudentsSpace(context) {
    return filteredStudents.isEmpty
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Expanded(
        child: ListView.builder(
          itemCount: filteredStudents.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () async {
                await storage.write(key: "student_id", value: filteredStudents[index].studentId.toString());
                goToStudentDetail(context);
              },
              child: Card(
                child: ListTile(
                  leading: ClipOval(
                    child: Image.memory(getStudentImage(
                        filteredStudents[index].data.toString())),
                  ),
                  title: Text(
                      "${filteredStudents[index].firstName.toString()} ${filteredStudents[index].lastName.toString()}"),
                  subtitle: Text(
                      "${filteredStudents[index].instituteName.toString()}, ${filteredStudents[index].groupName.toString()}"),
                  trailing: Text("${filteredStudents[index].score.toString()}"),
                ),
              ),
            );
          },
        )
    );
  }

  showFilters(context) {
    return AnimatedOpacity(
      opacity: isVisibleFilters ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Visibility(
        visible: isVisibleFilters,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                DropdownButton<InstituteModel>(
                  isExpanded: true,
                    value: filterInstitute,
                    items: institutesList.map((e) {
                      return new DropdownMenuItem(
                        child: Text(e.instituteFullName.toString()),
                        value: e,
                      );
                    }).toList(),
                    hint: Text("Институт"),
                    onChanged: (value) {
                      filterStream = null;
                      filterGroup = null;
                      filterInstitute = value;
                      fetchStreams();
                      filteredStudents = fetchedStudents.where((element) => element.instituteName!
                          .contains(value!.instituteFullName.toString())).toList();
                      notifyListeners();
                    }),
                DropdownButton<StreamModel>(
                  isExpanded: true,
                    value: filterStream,
                    items: streamsList.map((e) {
                      return new DropdownMenuItem(
                        child: Text(e.streamName.toString()),
                        value: e,
                      );
                    }).toList(),
                    hint: Text("Направление"),
                    onChanged: (value) {
                      filterGroup = null;
                      filterStream = value;
                      fetchGroups();
                      filteredStudents = fetchedStudents.where((element) => element.streamName!
                          .contains(value!.streamName.toString())).toList();
                      notifyListeners();
                    }),
                DropdownButton<GroupModel>(
                  isExpanded: true,
                    value: filterGroup,
                    items: groupsList.map((e) {
                      return new DropdownMenuItem(
                        child: Text(e.groupName.toString()),
                        value: e,
                      );
                    }).toList(),
                    hint: Text("Группа"),
                    onChanged: (value) {
                      filterGroup = value;
                      filteredStudents = fetchedStudents.where((element) => element.groupName!
                          .contains(value!.groupName.toString())).toList();
                      notifyListeners();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  goToStudentDetail(context) {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => DetailStudentScreen()));
  }

  changeVisibility(context) {
    isVisibleFilters = !isVisibleFilters;
    notifyListeners();
  }
}
