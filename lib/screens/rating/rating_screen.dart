import 'package:achieve_student_flutter/screens/rating/rating_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import '../../model/group.dart';
import '../../model/institute.dart';
import '../../model/stream.dart';

class RatingScreenRoute extends MaterialPageRoute {
  RatingScreenRoute() : super(builder: (context) => const RatingScreen());
}

class RatingScreen extends StatelessWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RatingViewModel>.reactive(
        viewModelBuilder: () => RatingViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, model) {
    return AppBar(
      title: Text("Рейтинг студентов",
          style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4065D8))),
      elevation: 0,
      backgroundColor: Colors.transparent,
      // bottom:
    );
  }

  _body(context, model) {
    return Column(
      children: [
        Row(
          children: [
            _searchTextView(context, model),
            IconButton(onPressed: () {model.changeVisibility(context);}, icon: Icon(Icons.filter_alt), color: Colors.blueAccent,)
          ],
        ),
        _showFilters(context, model),
        _buttonsTab(context, model),
        _topStudentsSpace(context, model)
      ],
    );
  }

  _searchTextView(context, model) {
    return Container(
      width: 300,
      height: 46,
      child: TextField(
        controller: model.searchController,
        onChanged: (value) {
          model.searchAction();
        },
        obscureText: false,
        style: TextStyle(fontFamily: 'OpenSans', fontSize: 14),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
            fillColor: Color(0xfff3f2f2),
            //suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: model.searchAction,),
            filled: true,
            hintText: "Фамилия студента"),
      ),
    );
  }

  _buttonsTab(context, model) {
    return Container(
      child: Row (
        children: [
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  model.fetchStudentsTop10();
                },
                child: Text("Топ-10")
            ),
          ),
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  model.fetchStudentsTop50();
                },
                child: Text("Топ-50")
            ),
          ),
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  model.fetchStudentsTop100();
                },
                child: Text("Топ-100")
            ),
          )
        ],
      ),
    );
  }

  _showFilters(context, model) {
    return AnimatedOpacity(
      opacity: model.isVisibleFilters ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Visibility(
        visible: model.isVisibleFilters,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                DropdownButton<InstituteModel>(
                    isExpanded: true,
                    value: model.filterInstitute,
                    items: model.institutesList.map<DropdownMenuItem<InstituteModel>>((e) {
                      return DropdownMenuItem<InstituteModel>(
                        child: Text(e.instituteFullName.toString()),
                        value: e,
                      );
                    }).toList(),
                    hint: Text("Институт"),
                    onChanged: (value) {
                      model.onChangeInstituteFilter(value);
                    }),
                DropdownButton<StreamModel>(
                    isExpanded: true,
                    value: model.filterStream,
                    items: model.streamsList.map<DropdownMenuItem<StreamModel>>((e) {
                      return DropdownMenuItem<StreamModel>(
                        child: Text(e.streamName.toString()),
                        value: e,
                      );
                    }).toList(),
                    hint: Text("Направление"),
                    onChanged: (value) {
                      model.onChangeStreamFilter(value);
                    }),
                DropdownButton<GroupModel>(
                    isExpanded: true,
                    value: model.filterGroup,
                    items: model.groupsList.map<DropdownMenuItem<GroupModel>>((e) {
                      return DropdownMenuItem<GroupModel>(
                        child: Text(e.groupName.toString()),
                        value: e,
                      );
                    }).toList(),
                    hint: Text("Группа"),
                    onChanged: (value) {
                      model.onChangeGroupFilter(value);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _topStudentsSpace(context, model) {
    return model.filteredStudents.isEmpty
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Expanded(
        child: ListView.builder(
          itemCount: model.filteredStudents.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                model.onTapStudent(context, model.filteredStudents[index].studentId.toString());
              },
              child: Card(
                child: ListTile(
                  leading: ClipOval(
                    child: Image.memory(model.getStudentImage(
                        model.filteredStudents[index].data.toString())),
                  ),
                  title: Text(
                      "${model.filteredStudents[index].firstName.toString()} ${model.filteredStudents[index].lastName.toString()}"),
                  subtitle: Text(
                      "${model.filteredStudents[index].instituteName.toString()}, ${model.filteredStudents[index].groupName.toString()}"),
                  trailing: Text("${model.filteredStudents[index].score.toString()}"),
                ),
              ),
            );
          },
        )
    );
  }
}
