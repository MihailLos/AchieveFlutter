import 'package:achieve_student_flutter/model/achieve_category.dart';
import 'package:achieve_student_flutter/model/reward.dart';
import 'package:achieve_student_flutter/screens/achievements/achievements_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class NewAchieveScreenRoute extends MaterialPageRoute {
  NewAchieveScreenRoute() : super(builder: (context) => const NewAchieveScreen());
}

class NewAchieveScreen extends StatelessWidget {
  const NewAchieveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewAchievementViewModel>.reactive(
        viewModelBuilder: () => NewAchievementViewModel(context),
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
      leading: IconButton(
        icon: Icon(Icons.arrow_back_outlined),
        color: Colors.black,
        onPressed: () async {
          model.goToUnreceivedFromNewAchievement(context);
        },
        iconSize: 32,
      ),
      elevation: 0,
      title: Text("Создание Достижения",
          style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4065D8))),
      backgroundColor: Colors.transparent,
    );
  }

  _body(context, NewAchievementViewModel model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 156,
                child: DropdownButton<AchieveCategoryModel>(
                  isExpanded: true,
                    value: model.achieveCategoryModel == null ? null : model.achieveCategoryModel,
                    items: model.achieveCategoryList.map<DropdownMenuItem<AchieveCategoryModel>>((e) {
                      return DropdownMenuItem<AchieveCategoryModel>(
                        child: Row(
                          children: [
                            Image.memory(model.getImage(e.data.toString()), width: 32, height: 32,),
                            Text(e.categoryName.toString())
                          ],
                        ),
                        value: e,
                      );
                    }).toList(),
                    hint: Text("Категория"),
                    onChanged: (value) {
                    model.achieveCategoryModel = value!;
                    model.notifyListeners();
                    }
                ),
              ),
              SizedBox(
                width: 156,
                child: DropdownButton<RewardModel>(
                  isExpanded: true,
                    value: model.chosenReward == null ? null : model.chosenReward,
                    items: model.rewardList.map<DropdownMenuItem<RewardModel>>((e) {
                      return DropdownMenuItem<RewardModel>(
                        child: FittedBox(
                          child: Row(
                            children: [
                              Image.memory(model.getImage(e.data.toString()), width: 32, height: 32,),
                              Text(e.rewardName.toString())
                            ],
                          ),
                        ),
                        value: e,
                      );
                    }).toList(),
                    hint: Text("Награда"),
                    onChanged: (value) {
                      model.chosenReward = value!;
                      model.notifyListeners();
                    }
                ),
              ),
            ],
          ),
          _newAchieveNameTextField(context, model),
          SizedBox(height: 32,),
          _newAchieveDescriptionTextField(context, model),
          SizedBox(height: 21,),
          _newAchieveScoreTextField(context, model),
          SizedBox(height: 21,),
          _dateButtons(context, model),
          SizedBox(height: 21,),
          _chooseImageButton(context, model),
          SizedBox(height: 21,),
          _chosenImagePlace(context, model),
          SizedBox(height: 21,),
          _sendNewAchieveButton(context, model),
        ],
      ),
    );
  }

  _newAchieveNameTextField(context, NewAchievementViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 334,
          child: TextField(
            controller: model.newAchievementTitle,
              decoration: InputDecoration(
                hintText: "Название достижения",
              )),
        ),
      ],
    );
  }

  _newAchieveDescriptionTextField(context, NewAchievementViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 334,
          child: TextField(
            controller: model.newAchievementDescription,
              maxLines: 15,
              decoration: InputDecoration(
                hintText: "Описание достижения",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              )),
        ),
      ],
    );
  }

  _newAchieveScoreTextField(context, NewAchievementViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 334,
          child: TextField(
              keyboardType: TextInputType.number,
              controller: model.newAchievementScore,
              decoration: InputDecoration(
                hintText: "Количество баллов",
              )),
        ),
      ],
    );
  }

  _dateButtons(context, NewAchievementViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
            ),
            child: ElevatedButton(
              child: model.getTextFromStartDateNewAchieve(),
              onPressed: () => model.pickStartNewAchieveDate(context),
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent
            ),
            child: ElevatedButton(
              child: model.getTextFromEndDateNewAchieve(),
              onPressed: () => model.pickEndNewAchieveDate(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                elevation: 0
              ),
            ),
          ),
        )
      ],
    );
  }

  _chooseImageButton(context, NewAchievementViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 334,
            height: 46,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color(0xFF4065D8),
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: Offset(0, 4)),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                model.pickNewAchievementImage(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo),
                  Text(
                    "Выбрать изображение",
                    style: TextStyle(
                        fontFamily: "Montseratt",
                        fontStyle: FontStyle.normal,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                primary: Color(0xFF4065D8),
              ),
            )
        ),
      ],
    );
  }

  _chosenImagePlace(context, NewAchievementViewModel model) {
    return model.newAchieveImage == null ?
    Text("Здесь вы можете посмотреть загружаемое изображение") :
        Image.memory(model.getImage(model.decodedNewAchieveImage.toString()));
  }

  _sendNewAchieveButton(context, NewAchievementViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
          width: 334,
          height: 46,
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffbfbfbf),
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: Offset(0, 4)),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              model.sendNewAchievementRequest(context);
            },
            child: Text(
              "Отправить",
              style: TextStyle(
                  fontFamily: "Montseratt",
                  fontStyle: FontStyle.normal,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              primary: Color(0xFFFF9966),
            ),
          )
      ),
    );
  }
}
