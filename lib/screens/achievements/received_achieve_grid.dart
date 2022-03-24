import 'package:achieve_student_flutter/screens/achievements/achievements_viewmodel.dart';
import 'package:achieve_student_flutter/screens/achievements/received_achieve_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

class ReceivedAchieveGridRoute extends MaterialPageRoute {
  ReceivedAchieveGridRoute() : super(builder: (context) => const ReceivedAchieveGrid());
}

class ReceivedAchieveGrid extends StatelessWidget {
  const ReceivedAchieveGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReceivedAchieveProfileViewModel>.reactive(
        viewModelBuilder: () => ReceivedAchieveProfileViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return _receivedProfileAchievementsGrid(context, model);
        });
  }

  _receivedProfileAchievementsGrid(context, ReceivedAchieveProfileViewModel model) {
    return model.circle
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Column(
      children: [
        IconButton(
          onPressed: () {
            model.changeVisibility(context);
          },
          icon: Icon(Icons.filter_alt, size: 30,),
          color: Colors.blueAccent,
        ),
        model.showFilters(context),
        GridView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: model.filteredReceivedProfileAchievements.length,
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: model.getImageForReceived(index),
              builder: (context, snapshot) {
                if (snapshot.hasData || snapshot.data != null) {
                  return InkWell(
                    onTap: () async {
                      await model.storage.write(key: "received_achieve_id", value: model.receivedProfileAchievements[index].receivedAchieveId.toString());
                      await model.storage.write(key: "achieve_id", value: model.receivedProfileAchievements[index].achieveId.toString());
                      model.goToDetailReceivedAchievement(context);
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: snapshot.data as ImageProvider,
                            fit: BoxFit.fill),
                        border: Border.all(
                            color:
                            model.filteredReceivedProfileAchievements[index]
                                .statusReward!
                                ? Colors.green
                                : Colors.orange,
                            width: 4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                "${model.filteredReceivedProfileAchievements[index].achieveName.toString()}",
                                style: CyrillicFonts.openSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 0.7
                                      ..color = Colors.black
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
        ),
      ],
    );
  }
}
