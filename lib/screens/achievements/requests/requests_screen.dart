import 'package:achieve_student_flutter/screens/achievements/requests/requests_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

class RequestsScreenRoute extends MaterialPageRoute {
  RequestsScreenRoute() : super(builder: (context) => const RequestsScreen());
}

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RequestsViewModel>.reactive(
        viewModelBuilder: () => RequestsViewModel(context),
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
      title: Text("Мои заявки",
          style: CyrillicFonts.raleway(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF4065D8))),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(onPressed: () {
          faqDialog(context);
        }, icon: const Icon(Icons.info_outline), color: const Color(0xFF4065D8), iconSize: 32,)
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
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          height: 36,
          padding: EdgeInsets.zero,
          decoration: const BoxDecoration(
              color: Color(0xFFa0b2ec),
              borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: ToggleButtons(
            borderRadius: BorderRadius.circular(15),
            selectedColor: const Color(0xFF4065D8),
            fillColor: Colors.white,
            renderBorder: true,
            color: Colors.white,
            constraints: BoxConstraints.expand(width: (constraints.maxWidth / 2) - 3),
            isSelected: model.isSelectedButton,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Получение", style: CyrillicFonts.openSans(fontSize: 12, fontWeight: FontWeight.w700),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Создание", style: CyrillicFonts.openSans(fontSize: 12, fontWeight: FontWeight.w700),),
              ),
            ],
            onPressed: (int newIndex) {
              model.onChangeToggle(newIndex, context);
            },
          ),
        ),
      ),
    );
  }

  faqDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              "Получение - вкладка предназначена для отображения заявок на получение достижений.\nСоздание - вкладка предназначена для отображения заявок на создание достижений."
            ),
          );
        }
    );
  }

  _createdAchievementsList(context, RequestsViewModel model) {
    return model.circle
        ? const Center(
      child: CircularProgressIndicator(),
    ) :
    model.createdAchievements.isEmpty ?
    Center(
      child: Text(
          "Нет заявок на создание достижений.",
          style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500)
      ),
    ) :
    Expanded(
        child: ListView.builder(
            itemCount: model.createdAchievements.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    await model.storage.write(key: "created_achieve_id", value: model.createdAchievements[index].achieveId.toString());
                    model.goToDetailCreatedAchievement(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 4),
                                  spreadRadius: 1,
                                  blurRadius: 7
                              )
                            ]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            model.getImage(model.createdAchievements[index].data.toString()),
                            width: 65,
                            height: 65,
                            fit: BoxFit.fill,),
                        ),
                      ),
                      const SizedBox(width: 16,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Создание достижения",
                              style: CyrillicFonts.raleway(
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),),
                            const SizedBox(height: 12,),
                            Text(model.createdAchievements[index].achieveName.toString(),
                              style: CyrillicFonts.raleway(
                                  fontSize: 11,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey
                              ),),
                            Text(model.createdAchievements[index].statusActive.toString(),
                              style: CyrillicFonts.openSans(
                                  fontSize: 11,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey
                              ),)
                          ],
                        ),
                      ),
                      model.createdAchievements[index].statusActive.toString() == "Одобрено" || model.createdAchievements[index].statusActive.toString() == "Активно" ?
                      const Icon(Icons.check, color: Colors.green, size: 32,) :
                      model.createdAchievements[index].statusActive.toString() == "Отклонено" || model.createdAchievements[index].statusActive.toString() == "Устарело" ?
                      const Icon(Icons.clear, color: Colors.red, size: 32,) :
                      const Icon(Icons.access_time_outlined, color: Colors.black, size: 32,)
                    ],
                  ),
                ),
              );
            }
        )
    );
  }

  _proofAchievementsList(context, RequestsViewModel model) {
    return model.circle
        ? const Center(
      child: CircularProgressIndicator(),
    ) :
    model.proofAchievements.isEmpty ?
    Center(
      child: Text(
          "Нет заявок на получение достижений.",
          style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500)
      ),
    ) :
    Expanded(
        child: ListView.builder(
            itemCount: model.proofAchievements.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    await model.storage.write(key: "proof_achieve_id", value: model.proofAchievements[index].proofId.toString());
                    model.goToDetailProofAchievement(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 4),
                                  spreadRadius: 1,
                                  blurRadius: 7
                              )
                            ]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            model.getImage(model.proofAchievements[index].achieveData.toString()),
                            width: 65,
                            height: 65,
                            fit: BoxFit.fill,),
                        ),
                      ),
                      const SizedBox(width: 16,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Получение достижения",
                              style: CyrillicFonts.raleway(
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),),
                            const SizedBox(height: 12,),
                            Text(model.proofAchievements[index].achieveName.toString(),
                              style: CyrillicFonts.openSans(
                                  fontSize: 11,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey
                              ),),
                            Text(model.proofAchievements[index].statusRequestName.toString(),
                              style: CyrillicFonts.openSans(
                                  fontSize: 11,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey
                              ),),
                            Text(model.proofAchievements[index].dateProof.toString(),
                              style: CyrillicFonts.openSans(
                                  fontSize: 11,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey
                              ),)
                          ],
                        ),
                      ),
                      model.proofAchievements[index].statusRequestName.toString() == "Подтверждено" ?
                      const Icon(Icons.check, color: Colors.green, size: 32,) :
                      model.proofAchievements[index].statusRequestName.toString() == "Отклонено" ?
                      const Icon(Icons.clear, color: Colors.red, size: 32,) :
                      model.proofAchievements[index].statusRequestName.toString() == "Просмотрено" ?
                      const Icon(Icons.remove_red_eye_outlined, color: Colors.blue, size: 32,) :
                      const Icon(Icons.access_time_outlined, color: Colors.black, size: 32,)
                    ],
                  ),
                ),
              );
            }
        )
    );
  }
}
