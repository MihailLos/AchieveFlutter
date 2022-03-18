import 'package:achieve_student_flutter/screens/achievements/achievements_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ReceivedAchieveGridRoute extends MaterialPageRoute {
  ReceivedAchieveGridRoute() : super(builder: (context) => const ReceivedAchieveGrid());
}

class ReceivedAchieveGrid extends StatelessWidget {
  const ReceivedAchieveGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AchievementsViewModel>.reactive(
        viewModelBuilder: () => AchievementsViewModel(context),
        onModelReady: (viewModel) => viewModel.onReadyReceivedAchieveGrid(),
        builder: (context, model, child) {
          return _receivedProfileAchievementsGrid(context, model);
        });
  }

  _receivedProfileAchievementsGrid(context, model) {
    return model.filteredReceivedProfileAchievements.isEmpty
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Column(
      children: [
        IconButton(
          onPressed: () {
            model.changeVisibility(context);
          },
          icon: Icon(Icons.filter_alt),
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
                    onTap: () {},
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
                                "${model.filteredReceivedProfileAchievements[index].achieveName.toString()}",
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
        ),
      ],
    );
  }
}
