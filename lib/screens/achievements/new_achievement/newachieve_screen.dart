import 'package:achieve_student_flutter/model/achievement/achieve_category.dart';
import 'package:achieve_student_flutter/model/reward/reward.dart';
import 'package:achieve_student_flutter/screens/achievements/new_achievement/new_achieve_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
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
              body: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) =>
                [
                  _appBar(context, model)
                ],
                body: _body(context, model),
              )
          );
        });
  }

  _appBar(context, model) {
    return SliverAppBar(
      floating: true,
      snap: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        color: Colors.black,
        onPressed: () async {
          model.goToUnreceivedFromNewAchievement(context);
        },
        iconSize: 32,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  _body(context, NewAchievementViewModel model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _title(context),
              ],
            ),
          ),
          const SizedBox(height: 22,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF4065D8)),
                    borderRadius: BorderRadius.circular(10)
                ),
                width: 156,
                height: 30,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AchieveCategoryModel>(
                    isExpanded: true,
                      value: model.achieveCategoryModel,
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
                      hint: Center(
                          child: Text(
                            "??????????????????",
                            style: CyrillicFonts.raleway(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontStyle: FontStyle.normal
                            ),
                          )
                      ),
                      onChanged: (value) {
                      model.achieveCategoryModel = value!;
                      model.notifyListeners();
                      }
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF4065D8)),
                    borderRadius: BorderRadius.circular(10)
                ),
                width: 156,
                height: 30,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<RewardModel>(
                    isExpanded: true,
                      value: model.chosenReward,
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
                      hint: Center(
                        child: Text(
                            "??????????????",
                            style: CyrillicFonts.raleway(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontStyle: FontStyle.normal
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        model.chosenReward = value!;
                        model.notifyListeners();
                      }
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          _newAchieveNameTextField(context, model),
          const SizedBox(height: 32,),
          _newAchieveDescriptionTextField(context, model),
          const SizedBox(height: 21,),
          _newAchieveScoreTextField(context, model),
          const SizedBox(height: 21,),
          _dateButtons(context, model),
          const SizedBox(height: 21,),
          _chooseImageButton(context, model),
          const SizedBox(height: 21,),
          _chosenImagePlace(context, model),
          const SizedBox(height: 21,),
          _sendNewAchieveButton(context, model),
        ],
      ),
    );
  }

  _newAchieveNameTextField(context, NewAchievementViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 334,
          child: TextField(
            autofocus: false,
            controller: model.newAchievementTitle,
              decoration: InputDecoration(
                hintText: "???????????????? ????????????????????",
                hintStyle: CyrillicFonts.openSans(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 14
                )
              )),
        ),
      ],
    );
  }

  _newAchieveDescriptionTextField(context, NewAchievementViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 334,
          child: TextField(
            autofocus: false,
            controller: model.newAchievementDescription,
              maxLines: 15,
              decoration: InputDecoration(
                hintText: "???????????????? ????????????????????",
                  hintStyle: CyrillicFonts.openSans(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 14
                  ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              )),
        ),
      ],
    );
  }

  _newAchieveScoreTextField(context, NewAchievementViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 334,
          child: TextField(
            autofocus: false,
              keyboardType: TextInputType.number,
              controller: model.newAchievementScore,
              decoration: InputDecoration(
                hintText: "???????????????????? ?????????????????????? ????????????",
                  hintStyle: CyrillicFonts.openSans(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 14
                  )
              )),
        ),
      ],
    );
  }

  _dateButtons(context, NewAchievementViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: const BoxDecoration(
          ),
          child: OutlinedButton(
            child: model.getTextFromStartDateNewAchieve(),
            onPressed: () => model.pickStartNewAchieveDate(context),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent
          ),
          child: OutlinedButton(
            child: model.getTextFromEndDateNewAchieve(),
            onPressed: () => model.pickEndNewAchieveDate(context),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  _chooseImageButton(context, NewAchievementViewModel model) {
    return SizedBox(
        width: 334,
        height: 46,
        child: OutlinedButton(
          onPressed: () {
            model.pickNewAchievementImage(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.attach_file, color: Color(0xFF4065D8),),
              Text(
                "???????????????????? ??????????????????????",
                style: CyrillicFonts.openSans(
                    fontStyle: FontStyle.normal,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ],
          ),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        )
    );
  }

  _chosenImagePlace(context, NewAchievementViewModel model) {
    return model.newAchieveImage == null ?
    const Text("") :
        Image.memory(model.getImage(model.decodedNewAchieveImage.toString()), width: 200, height: 200,);
  }

  _sendNewAchieveButton(context, NewAchievementViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
          width: 334,
          height: 46,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0, 6),
                  spreadRadius: 1,
                  blurRadius: 7
              )
            ],
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFBC89),
                Color(0xFFFF9A67)
              ],
            ),
          ),
          child: TextButton(
            onPressed: () async {
              model.sendNewAchievementRequest(context);
            },
            child: Text(
              "??????????????????",
              style: CyrillicFonts.raleway(
                fontStyle: FontStyle.normal,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,),
            ),

          )
      ),
    );
  }

  _title(context) {
    return Text("???????????????? ????????????????????",
        style: CyrillicFonts.raleway(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF4065D8)
        )
    );
  }
}
