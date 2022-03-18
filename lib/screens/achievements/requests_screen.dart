import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'achievements_viewmodel.dart';

class RequestsScreenRoute extends MaterialPageRoute {
  RequestsScreenRoute() : super(builder: (context) => const RequestsScreen());
}

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AchievementsViewModel>.reactive(
        viewModelBuilder: () => AchievementsViewModel(context),
        onModelReady: (viewModel) => viewModel.onReadyRequests(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, model) {
    return AppBar(
      title: Text("Мои Заявки",
          style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4065D8))),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(onPressed: () {
          faqDialog(context);
        }, icon: Icon(Icons.info_outline), color: Color(0xFF4065D8), iconSize: 32,)
      ],
      // bottom:
    );
  }

  _body(context, model) {
    return Column(
      children: [
        _buttonsTab(context, model),
        model.isProof ? _proofAchievementsList(context, model) : _createdAchievementsList(context, model)
      ],
    );
  }

  _buttonsTab(context, model) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD3D3D3),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row (
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    model.proofAchieveButtonActive(context);
                    model.changeRequestsProofAchievements(context);
                  },
                  child: Text("Подтверждение", style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(
                  primary: model.isProofAchieveButtonTapped ? Colors.white : Colors.transparent,
                  elevation: 0
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    model.createdAchieveButtonActive(context);
                    model.changeRequestsCreatedAchievements(context);
                  },
                  child: Text("Создание", style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(
                    primary: model.isCreatedAchieveButtonTapped ? Colors.white : Colors.transparent,
                  elevation: 0
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  faqDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Подтверждение - вкладка предназначена для отображения заявок на получение достижений.\nСоздание - вкладка предназначена для отображения заявок на создание достижений."
            ),
          );
        }
    );
  }

  _createdAchievementsList(context, model) {
    return model.createdAchievements.isEmpty
        ? Center(
      child: CircularProgressIndicator(),
    ) : Expanded(
        child: ListView.builder(
            itemCount: model.createdAchievements.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            model.getImage(model.createdAchievements[index].data.toString()),
                            width: 65,
                            height: 65,
                            fit: BoxFit.fill,),
                        ),
                        SizedBox(width: 16,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Создание достижения",
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),),
                              SizedBox(height: 12,),
                              Text(model.createdAchievements[index].achieveName.toString(),
                                style: GoogleFonts.openSans(
                                    fontSize: 11,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey
                                ),),
                              Text(model.createdAchievements[index].statusActive.toString(),
                                style: GoogleFonts.openSans(
                                    fontSize: 11,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey
                                ),)
                            ],
                          ),
                        ),
                        model.createdAchievements[index].statusActive.toString() == "Одобрено" || model.createdAchievements[index].statusActive.toString() == "Активно" ?
                        Icon(Icons.check, color: Colors.green, size: 32,) :
                        model.createdAchievements[index].statusActive.toString() == "Отклонено" || model.createdAchievements[index].statusActive.toString() == "Устарело" ?
                        Icon(Icons.clear, color: Colors.red, size: 32,) :
                        Icon(Icons.access_time_outlined, color: Colors.black, size: 32,)
                      ],
                    ),
                  ),
                ),
              );
            }
        )
    );
  }

  _proofAchievementsList(context, model) {
    return model.proofAchievements.isEmpty
        ? Center(
      child: CircularProgressIndicator(),
    ) : Expanded(
        child: ListView.builder(
            itemCount: model.proofAchievements.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            model.getImage(model.proofAchievements[index].achieveData.toString()),
                            width: 65,
                            height: 65,
                            fit: BoxFit.fill,),
                        ),
                        SizedBox(width: 16,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Получение достижения",
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),),
                              SizedBox(height: 12,),
                              Text(model.proofAchievements[index].achieveName.toString(),
                                style: GoogleFonts.openSans(
                                    fontSize: 11,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey
                                ),),
                              Text(model.proofAchievements[index].statusRequestName.toString(),
                                style: GoogleFonts.openSans(
                                    fontSize: 11,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey
                                ),),
                              Text(model.proofAchievements[index].dateProof.toString(),
                                style: GoogleFonts.openSans(
                                    fontSize: 11,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey
                                ),)
                            ],
                          ),
                        ),
                        model.proofAchievements[index].statusRequestName.toString() == "Подтверждено" ?
                        Icon(Icons.check, color: Colors.green, size: 32,) :
                        model.proofAchievements[index].statusRequestName.toString() == "Отклонено" ?
                        Icon(Icons.clear, color: Colors.red, size: 32,) :
                        model.proofAchievements[index].statusRequestName.toString() == "Просмотрено" ?
                        Icon(Icons.remove_red_eye_outlined, color: Colors.blue, size: 32,) :
                        Icon(Icons.access_time_outlined, color: Colors.black, size: 32,)
                      ],
                    ),
                  ),
                ),
              );
            }
        )
    );
  }
}
