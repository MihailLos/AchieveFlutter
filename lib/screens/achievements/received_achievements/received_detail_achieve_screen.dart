import 'package:achieve_student_flutter/screens/achievements/received_achievements/received_detail_achieve_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

class ReceivedDetailAchieveScreenRoute extends MaterialPageRoute {
  ReceivedDetailAchieveScreenRoute()
      : super(builder: (context) => const ReceivedDetailAchieveScreen());
}

class ReceivedDetailAchieveScreen extends StatelessWidget {
  const ReceivedDetailAchieveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReceivedDetailAchieveViewModel>.reactive(
        viewModelBuilder: () => ReceivedDetailAchieveViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return model.circle
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Scaffold(
              body: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) =>
                [
                  SliverAppBar(
                    expandedHeight: 350,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _achieveImage(context, model),
                    ),
                    leading: IconButton(
                      icon: ClipOval(
                        child: Container(
                            width: 64,
                            height: 64,
                            color: Colors.grey.withOpacity(0.25),
                            child: Icon(Icons.clear)
                        ),
                      ),
                      color: Colors.black,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      iconSize: 32,
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  )
                ],
                body: _receivedAchieveBody(context, model),
              )
          );
        });
  }

  _receivedAchieveBody(context, ReceivedDetailAchieveViewModel model) {
    return ListView(
      children: [
        //_achieveImage(context, model),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 27, horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _authorName(context, model),
              SizedBox(height: 8,),
              _achieveName(context, model),
              SizedBox(height: 38,),
              _achieveDescription(context, model),
              SizedBox(height: 12,),
              _achieveReward(context, model),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _achieveCategory(context, model),
                  SizedBox(width: 84,),
                  _achieveStatus(context, model)
                ],
              ),
              model.receivedAchieve!.statusReward! ?
              Text("Вы получили награду за это достижение. Поздравляем!",
                style: CyrillicFonts.raleway(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontSize: 14
                ),
              ) : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                child: Container(
                    width: double.maxFinite,
                    height: 46,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0, 6),
                            spreadRadius: 1,
                            blurRadius: 7
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
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
                        _getRewardAlert(context, model);
                      },
                      child: Text(
                        "Получить награду",
                        style: CyrillicFonts.raleway(
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,),
                      ),

                    )
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _achieveImage(context, ReceivedDetailAchieveViewModel model) {
    return Image.memory(
      model.getImage(model.receivedAchieve!.achieveData!),
      width: double.maxFinite,
      height: 300,
      fit: BoxFit.cover,
    );
  }

  _authorName(context, ReceivedDetailAchieveViewModel model) {
    return Text(
      "Автор: ${model.receivedAchieve?.creatorFirstName} ${model.receivedAchieve?.creatorLastName}",
      style: CyrillicFonts.raleway(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          color: Colors.grey,
          fontSize: 14
      ),
    );
  }

  _achieveName(context, ReceivedDetailAchieveViewModel model) {
    return Text("${model.receivedAchieve?.achieveName}",
      style: CyrillicFonts.raleway(
          fontWeight: FontWeight.w800,
          fontSize: 24,
          fontStyle: FontStyle.normal,
          color: Color(0xFF4065D8)
      ),
    );
  }

  _achieveDescription(context, ReceivedDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Описание:",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Text(
          "${model.receivedAchieve!.achieveDescription}",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        )
      ],
    );
  }

  _achieveReward(context, ReceivedDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Награда: ",
              style: CyrillicFonts.raleway(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 14
              ),
            ),
            model.receivedAchieve!.statusReward! ?
            Text("Получена",
              style: CyrillicFonts.raleway(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  color: Colors.green,
                  fontSize: 14
              ),
            ) :
            Text("Не получена",
              style: CyrillicFonts.raleway(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  color: Color(0xFFFF9966),
                  fontSize: 14
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.memory(model.getImage(model.receivedAchieve!.rewardData.toString()), width: 24, height: 24,),
            Text(
              "${model.receivedAchieve!.rewardName}",
              style: CyrillicFonts.raleway(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 14
              ),
            )
          ],
        )
      ],
    );
  }

  _achieveCategory(context, ReceivedDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Категория:",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Row(
          children: [
            Image.memory(model.getImage(model.receivedAchieve!.categoryData.toString()), width: 24, height: 24,),
            Text(
              "${model.receivedAchieve!.categoryName}",
              style: CyrillicFonts.raleway(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 14
              ),
            )
          ],
        )
      ],
    );
  }

  _achieveStatus(context, ReceivedDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Статус:",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Row(
          children: [
            Icon(Icons.check, color: Colors.green,),
            Text(
              "Выполнено",
              style: CyrillicFonts.raleway(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 14
              ),
            ),
          ],
        )
      ],
    );
  }

  _getRewardAlert(context, ReceivedDetailAchieveViewModel model) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text(
                "Подтверждение",
              style: CyrillicFonts.raleway(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF5878DD)
              ),
            )
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Вы действительно хотите подтвердить получение награды?",
                  style: CyrillicFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF757575)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 6),
                              spreadRadius: 1,
                              blurRadius: 7
                          )
                        ],
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
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
                          model.getRewardAction(context);
                        },
                        child: Text(
                          "Подтвердить",
                          style: CyrillicFonts.raleway(
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,),
                        ),

                      )
                  ),
                ),
                Text(
                    "Подтверждайте получение наград только перед выдачей приза.",
                    style: CyrillicFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF757575)
                    ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Отмена")
              ),
            ],
          );
        }
    );
  }
}
