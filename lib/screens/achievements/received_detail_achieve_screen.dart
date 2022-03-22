import 'package:achieve_student_flutter/screens/achievements/received_detail_achieve_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          return Scaffold(
            appBar: _appBar(context, model),
            body: _receivedAchieveBody(context, model),
          );
        });
  }

  _appBar(context, ReceivedDetailAchieveViewModel model) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_outlined),
        color: Colors.black,
        onPressed: () async {
          Navigator.pop(context);
        },
        iconSize: 32,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  _receivedAchieveBody(context, ReceivedDetailAchieveViewModel model) {
    return model.circle
        ? Center(
      child: CircularProgressIndicator(),
    )
        : ListView(
      children: [
        _achieveImage(context, model),
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
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontSize: 14
                ),
              ) : Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Container(
                    width: double.maxFinite,
                    height: 46,
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: Offset(0, 4)),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _getRewardAlert(context, model);
                      },
                      child: Text(
                        "Получить награду",
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
      style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          color: Colors.black,
          fontSize: 14
      ),
    );
  }

  _achieveName(context, ReceivedDetailAchieveViewModel model) {
    return Text("${model.receivedAchieve?.achieveName}",
      style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
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
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Text(
          "${model.receivedAchieve!.achieveDescription}",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w300,
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
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 14
              ),
            ),
            model.receivedAchieve!.statusReward! ?
            Text("Получена",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  color: Colors.green,
                  fontSize: 14
              ),
            ) :
            Text("Не получена",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
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
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w300,
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
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
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
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w300,
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
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
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
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w300,
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
            title: Text("Подтверждение"),
            content: Text("Вы действительно хотите подтвердить получение награды? Подтверждайте получение наград только после выдачи приза"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Отмена")
              ),
              TextButton(
                  onPressed: () => model.getRewardAction(context),
                  child: Text("Подтвердить")
              ),
            ],
          );
        }
    );
  }
}
