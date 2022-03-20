import 'package:achieve_student_flutter/screens/achievements/achievements_viewmodel.dart';
import 'package:achieve_student_flutter/screens/achievements/unreceived_achieve_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      title: Text("Неполученные Достижения",
          style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4065D8))),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(onPressed: () {model.goToNewAchievement(context);}, icon: Icon(Icons.add_box), color: Color(0xFF4065D8), iconSize: 32,)
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
    return Container(
      child: Row (
        children: [
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  model.fetchUnreceivedAchievements();
                },
                child: Text("Активные")
            ),
          ),
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  model.fetchUnreceivedAchievements(2);
                },
                child: Text("Неактивные")
            ),
          ),
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  model.fetchUnreceivedAchievements(4);
                },
                child: Text("Устаревшие")
            ),
          )
        ],
      ),
    );
  }

  _unreceivedAchievementsList(context, UnreceivedAchieveViewModel model) {
    return model.filteredUnreceivedProfileAchievements.isEmpty
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Expanded(
        child: ListView.builder(
            itemCount: model.filteredUnreceivedProfileAchievements.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                model.getImage(model.filteredUnreceivedProfileAchievements[index].achieveData.toString()),
                                width: 65,
                                height: 65,
                                fit: BoxFit.fill,),
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
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),),
                              SizedBox(height: 12,),
                              Text(model.filteredUnreceivedProfileAchievements[index].achieveDescription.toString(),
                                style: GoogleFonts.openSans(
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
                              style: GoogleFonts.montserrat(
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
                ),
              );
            }));
  }
}
