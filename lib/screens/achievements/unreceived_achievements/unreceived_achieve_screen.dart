import 'package:achieve_student_flutter/screens/achievements/new_achievement/new_achieve_viewmodel.dart';
import 'package:achieve_student_flutter/screens/achievements/unreceived_achievements/unreceived_achieve_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

class UnreceivedAchieveScreenRoute extends MaterialPageRoute {
  UnreceivedAchieveScreenRoute() : super(builder: (context) => const UnreceivedAchieveScreen());
}

class UnreceivedAchieveScreen extends StatelessWidget {
  const UnreceivedAchieveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UnreceivedAchieveViewModel>.reactive(
        viewModelBuilder: () => UnreceivedAchieveViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, UnreceivedAchieveViewModel model) {
    return AppBar(
      title: Text("Достижения",
          style: CyrillicFonts.raleway(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF4065D8))),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(onPressed: () {model.goToNewAchievement(context);}, icon: Icon(Icons.add_box), color: Color(0xFF4065D8), iconSize: 36,)
      ],
      // bottom:
    );
  }

  _body(context, UnreceivedAchieveViewModel model) {
    return Column(
      children: [
        _buttonsTab(context, model),
        _unreceivedAchievementsList(context, model)
      ],
    );
  }

  _buttonsTab(context, UnreceivedAchieveViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          height: 36,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
              color: Color(0xFFa0b2ec),
              borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: ToggleButtons(
            borderRadius: BorderRadius.circular(15),
            selectedColor: Color(0xFF4065D8),
            fillColor: Colors.white,
            renderBorder: true,
            color: Colors.white,
            constraints: BoxConstraints.expand(width: (constraints.maxWidth / 3) - 3),
            isSelected: model.isSelectedButton,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Активные", style: CyrillicFonts.openSans(fontSize: 12, fontWeight: FontWeight.w700),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Неактивные", style: CyrillicFonts.openSans(fontSize: 12, fontWeight: FontWeight.w700),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Устаревшие", style: CyrillicFonts.openSans(fontSize: 12, fontWeight: FontWeight.w700),),
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

  _unreceivedAchievementsList(context, UnreceivedAchieveViewModel model) {
    return model.circle
        ? Center(
      child: CircularProgressIndicator(),
    )
        :
    model.filteredUnreceivedProfileAchievements.isEmpty ?
    Center(
      child: Text(
          "Нет достижений.",
          style: CyrillicFonts.raleway(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500)
      ),
    ) :
    Expanded(
        child: ListView.builder(
            itemCount: model.filteredUnreceivedProfileAchievements.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  await model.storage.write(key: "unreceived_achieve_id", value: model.filteredUnreceivedProfileAchievements[index].achieveId.toString());
                  model.goToDetailAchievement(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 4),
                                    spreadRadius: 1,
                                    blurRadius: 7
                                )
                              ]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                model.getImage(model.filteredUnreceivedProfileAchievements[index].achieveData.toString()),
                                width: 65,
                                height: 65,
                                fit: BoxFit.fill,),
                            ),
                          ),
                          Positioned(
                            child: ClipOval(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Colors.white,
                                child: Image.memory(model.getImage(
                                    model.filteredUnreceivedProfileAchievements[index]
                                        .categoryData.toString()), width: 15, height: 15, color: Colors.black,),
                              ),
                            ),
                            bottom: 0,
                            right: 1,)
                        ],
                      ),
                      SizedBox(width: 16,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(model.filteredUnreceivedProfileAchievements[index].achieveName.toString(),
                              style: CyrillicFonts.raleway(
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),),
                            SizedBox(height: 12,),
                            Text(model.filteredUnreceivedProfileAchievements[index].achieveDescription.toString(),
                              style: CyrillicFonts.openSans(
                                  fontSize: 11,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey
                              ),)
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("+${model.filteredUnreceivedProfileAchievements[index].score.toString()}",
                            style: CyrillicFonts.montserrat(
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF4065D8)),),
                          Image.asset("assets/images/prize_icon.png", width: 30, height: 30,),
                          Image.memory(model.getImage(model.filteredUnreceivedProfileAchievements[index].rewardData.toString()), width: 30, height: 30,)
                        ],
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}
