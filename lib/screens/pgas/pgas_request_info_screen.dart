import 'package:achieve_student_flutter/screens/pgas/pgas_request_info_viewmodel.dart';
import 'package:achieve_student_flutter/screens/pgas/pgas_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

class PgasRequestInfoScreenRoute extends MaterialPageRoute {
  PgasRequestInfoScreenRoute() : super(builder: (context) => const PgasRequestInfoScreen());
}

class PgasRequestInfoScreen extends StatelessWidget {
  const PgasRequestInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PgasRequestInfoViewModel>.reactive(
        viewModelBuilder: () => PgasRequestInfoViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return model.circle ? const Center(child: CircularProgressIndicator(),) : Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, PgasRequestInfoViewModel model) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        color: Colors.black,
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PgasScreen()));
        },
        iconSize: 32,
      ),
      actions: [
        IconButton(
            onPressed: () {
              model.goToEditPgasRequestScreen(context);
            },
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF5878DD), size: 32,)
        ),
        IconButton(
            onPressed: () {
              _deleteRequestAlert(context, model);
            },
            icon: const Icon(Icons.delete_outline, color: Color(0xFF5878DD), size: 32,)
        )
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  _body(context, PgasRequestInfoViewModel model) {
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
          _infoTextField(context, const Icon(Icons.person, color: Color(0xFF4065D8),), model.pgasRequest!.surname.toString(), "Фамилия"),
          _infoTextField(context, const Icon(Icons.person, color: Color(0xFF4065D8),), model.pgasRequest!.name.toString(), "Имя"),
          _infoTextField(context, const Icon(Icons.person, color: Color(0xFF4065D8),), model.pgasRequest!.patronymic.toString(), "Отчество"),
          _infoTextField(context, const Icon(Icons.phone, color: Color(0xFF4065D8),), model.pgasRequest!.phone.toString(), "Номер телефона"),
          _infoTextField(context, const Icon(Icons.school, color: Color(0xFF4065D8),), model.pgasRequest!.facultyName.toString(), "Институт"),
          _infoTextField(context, const Icon(Icons.school, color: Color(0xFF4065D8),), model.pgasRequest!.group.toString(), "Группа"),
          _infoTextField(context, null, model.pgasRequest!.courseNum.toString(), "Курс"),
          _infoTextField(context, null, model.pgasRequest!.studyYear.toString(), "Учебный год"),
          _infoTextField(context, null, model.pgasRequest!.semesterType.toString(), "Семестр"),
        ],
      ),
    );
  }

  _title(context) {
    return Text("Ваша заявка",
        style: CyrillicFonts.raleway(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF4065D8)
        )
    );
  }

  _deleteRequestAlert(context, PgasRequestInfoViewModel model) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                "Удаление заявки на ПГАС",
                textAlign: TextAlign.center,
                style: CyrillicFonts.raleway(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF5878DD)
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Вы действительно хотите удалить заявку?",
                  style: CyrillicFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF757575)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 6),
                              spreadRadius: 1,
                              blurRadius: 7
                          )
                        ],
                        borderRadius: BorderRadius.circular(25),
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
                          model.deletePgasAction(context);
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
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Отмена")
              ),
            ],
          );
        }
    );
  }

  _infoTextField(context, Icon? prefixIcon, String dataString, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF4065D8)
          )
        ),
        initialValue: dataString,
      ),
    );
  }
}
