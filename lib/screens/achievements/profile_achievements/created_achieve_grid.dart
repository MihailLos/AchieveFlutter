import 'package:achieve_student_flutter/screens/achievements/new_achievement/new_achieve_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

import 'created_achieve_profile_viewmodel.dart';

class CreatedAchieveGridRoute extends MaterialPageRoute {
  CreatedAchieveGridRoute() : super(builder: (context) => const CreatedAchieveGrid());
}

class CreatedAchieveGrid extends StatelessWidget {
  const CreatedAchieveGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreatedAchieveProfileViewModel>.reactive(
        viewModelBuilder: () => CreatedAchieveProfileViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return _createdProfileAchievementsGrid(context, model);
        });
  }

  _createdProfileAchievementsGrid(context, CreatedAchieveProfileViewModel model) {
    return model.circle
        ? Center(
      child: CircularProgressIndicator(),
    )
        : model.createdProfileAchievements.isEmpty ?
    Center(
      child: Text(
          "Нет созданных достижений.",
          style: CyrillicFonts.raleway(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500)
      ),
    ) :
    GridView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: model.createdProfileAchievements.length,
      itemBuilder: (BuildContext context, int index) {
        return FutureBuilder(
          future: model.getImageForCreated(index),
          builder: (context, snapshot) {
            if (snapshot.hasData || snapshot.data != null) {
              return InkWell(
                onTap: () async {
                  await model.storage.write(key: "created_achieve_id", value: model.createdProfileAchievements[index].achieveId.toString());
                  model.goToDetailCreatedAchievement(context);
                },
                child: Container(
                  width: 100,
                  height: 200,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: snapshot.data as ImageProvider,
                        fit: BoxFit.fill),
                    border: Border.all(color: Colors.lightBlue, width: 4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            "${model.createdProfileAchievements[index].achieveName.toString()}",
                            style: CyrillicFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white
                            ),
                          ))
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Произошла ошибка"),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
