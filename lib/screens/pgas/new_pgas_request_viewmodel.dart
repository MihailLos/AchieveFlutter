import 'dart:convert';

import 'package:achieve_student_flutter/model/pgas/faculty.dart';
import 'package:achieve_student_flutter/model/pgas/semester_type.dart';
import 'package:achieve_student_flutter/screens/pgas/pgas_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class NewPgasRequestViewModel extends BaseViewModel {
  NewPgasRequestViewModel(BuildContext context);
  FlutterSecureStorage storage = const FlutterSecureStorage();
  List<FacultyModel> facultiesList = [];
  List<SemesterTypeModel> semestersList = [];
  FacultyModel? chooseFaculty;
  SemesterTypeModel? chooseSemester;
  final studyYears = ["2021-2022"];
  final courses = ["1", "2", "3", "4", "5",];
  TextEditingController surnameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  String? chosenYear;
  String? chosenCourse;
  TextEditingController courseController = TextEditingController();

  Future onReady() async {
    await fetchInstitutesList();
    await fetchSemesterTypeList();
  }

  fetchInstitutesList() async {
    String? eiosAccessToken = await storage.read(key: "eios_token");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getFacultyList"), headers: header);
    facultiesList = parseFaculties(json.decode(response.body)["result"]);
    notifyListeners();
  }

  fetchSemesterTypeList() async {
    String? eiosAccessToken = await storage.read(key: "eios_token");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getSemesterTypeList"), headers: header);
    semestersList = parseSemesterTypes(json.decode(response.body)["result"]);
    notifyListeners();
  }

  List<FacultyModel> parseFaculties(List response) {
    return response
        .map<FacultyModel>((json) => FacultyModel.fromJson(json))
        .toList();
  }

  List<SemesterTypeModel> parseSemesterTypes(List response) {
    return response
        .map<SemesterTypeModel>((json) => SemesterTypeModel.fromJson(json))
        .toList();
  }
  
  sendButtonAction(context) async {
    String? eiosAccessToken = await storage.read(key: "eios_token");
    if (surnameController.text.isNotEmpty && firstNameController.text.isNotEmpty &&
    phoneController.text.isNotEmpty && middleNameController.text.isNotEmpty && groupController.text.isNotEmpty &&
    chosenYear!.isNotEmpty && chosenCourse!.isNotEmpty && chooseSemester != null && chooseFaculty != null) {
      Map<String, String> header = {
        "X-Access-Token": "$eiosAccessToken"
      };

      Map<String, dynamic> body = {
        "surname": surnameController.text,
        "name": firstNameController.text,
        "patronymic": middleNameController.text,
        "phone": phoneController.text,
        "group": groupController.text,
        "studyYear": chosenYear,
        "courseNum": chosenCourse,
        "semesterTypeId": chooseSemester!.semesterTypeId.toString(),
        "facultyId": chooseFaculty!.id.toString()
      };

      var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/addRequest"), headers: header, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const PgasScreen()), (Route<dynamic> route) => false);
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("???????? ???????????? ?????????????? ????????????????????.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("???????????? ?????? ???????????????? ????????????! ?????? ????????????: ${response.statusCode}")));
        print(response.body);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("?????????????????? ?????? ???????? ????????????!")));
    }
  }
}