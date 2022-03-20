import 'package:achieve_student_flutter/screens/achievements/achievements_viewmodel.dart';
import 'package:flutter/material.dart';
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
    return model.createdProfileAchievements.isEmpty
        ? Center(
      child: CircularProgressIndicator(),
    )
        : GridView.builder(
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
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: snapshot.data as ImageProvider,
                        fit: BoxFit.fill),
                    border: Border.all(color: Colors.lightBlue, width: 4),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0xffbfbfbf),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            "${model.createdProfileAchievements[index].achieveName.toString()}",
                            style: TextStyle(color: Colors.white),
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
