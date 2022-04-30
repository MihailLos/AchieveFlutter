import 'package:achieve_student_flutter/model/education/stream.dart';
import 'package:achieve_student_flutter/screens/rating/rating_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

import '../../model/education/group.dart';
import '../../model/education/institute.dart';

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
            body: _body(context, model),
          );
        });
  }

  _body(context, model) {
    return Column(
      children: [
        _searchTextView(context, model),
        _titleAndFilters(context, model),
        _showFilters(context, model),
        _buttonsTab(context, model),
        _topStudentsSpace(context, model)
      ],
    );
  }

  _searchTextView(context, model) {
    return Container(
      color: const Color(0xFF39ABDF),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 0),
        child: SizedBox(
          width: double.maxFinite,
          height: 46,
          child: TextField(
            controller: model.searchController,
            obscureText: false,
            style: const TextStyle(fontFamily: 'OpenSans', fontSize: 16, color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Поиск",
                hintStyle: CyrillicFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {
                    model.searchAction();
                    },
                  iconSize: 32,)
            ),
          ),
        ),
      ),
    );
  }

  _titleAndFilters(context, RatingViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Рейтинг студентов",
              style: CyrillicFonts.raleway(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF4065D8)
              )
          ),
          IconButton(onPressed: () {model.changeVisibility(context);}, icon: const Icon(Icons.filter_alt, size: 32,), color: Colors.blueAccent,)
        ],
      ),
    );
  }

  _buttonsTab(context, RatingViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          height: 36,
          padding: EdgeInsets.zero,
          decoration: const BoxDecoration(
              color: Color(0xFF39ABDF),
              borderRadius: BorderRadius.all(Radius.circular(180)),
              boxShadow: [
                BoxShadow(
                    color: Color(0xFFFF9966),
                    offset: Offset(0, 3.5),
                    spreadRadius: 1,
                    blurRadius: 7
                )
              ]
          ),
          child: ToggleButtons(
            borderRadius: BorderRadius.circular(180),
            selectedColor: Colors.white,
            fillColor: const Color(0xFFFF9966),
            renderBorder: false,
            color: Colors.white,
            constraints: BoxConstraints.expand(width: (constraints.maxWidth / 3) - 3),
            isSelected: model.isSelectedButton,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Топ 10", style: CyrillicFonts.openSans(fontSize: 12, fontWeight: FontWeight.w700),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Топ 50", style: CyrillicFonts.openSans(fontSize: 12, fontWeight: FontWeight.w700),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Топ 100", style: CyrillicFonts.openSans(fontSize: 12, fontWeight: FontWeight.w700),),
              ),
            ],
            onPressed: (int newIndex) {
              model.onChangeToggle(newIndex);
            },
          ),
        ),
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
                    hint: const Text("Институт"),
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
                    hint: const Text("Направление"),
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
                    hint: const Text("Группа"),
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

  _topStudentsSpace(context, RatingViewModel model) {
    return model.circle
        ? const Center(
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
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${index + 1}", style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w800)),
                    const SizedBox(width: 11,),
                    ClipOval(
                      child: Image.memory(model.getStudentImage(
                          model.filteredStudents[index].data.toString()), width: 61, height: 61,),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${model.filteredStudents[index].firstName.toString()} ${model.filteredStudents[index].lastName.toString()}",
                            style: CyrillicFonts.raleway(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),),
                          const SizedBox(height: 16,),
                          Text(
                              "${model.filteredStudents[index].instituteName.toString()}, ${model.filteredStudents[index].groupName.toString()}",
                              style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w700))
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          model.filteredStudents[index].score.toString(),
                          style: CyrillicFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              color: const Color(0xFF4065D8)),
                        ),
                        const Image(image: AssetImage("assets/images/prize_icon.png"))
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        )
    );
  }
}
