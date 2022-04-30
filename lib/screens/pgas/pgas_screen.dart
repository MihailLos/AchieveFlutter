import 'package:achieve_student_flutter/screens/home_view.dart';
import 'package:achieve_student_flutter/screens/pgas/pgas_viewmodel.dart';
import 'package:achieve_student_flutter/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

class PgasScreenRoute extends MaterialPageRoute {
  PgasScreenRoute() : super(builder: (context) => const PgasScreen());
}

class PgasScreen extends StatelessWidget {
  const PgasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PgasViewModel>.reactive(
        viewModelBuilder: () => PgasViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(context),
        builder: (context, model, child) {
          return model.circle ? const Center(child: CircularProgressIndicator(),) : Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, PgasViewModel model) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        color: Colors.black,
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
        },
        iconSize: 32,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  _body(context, model) {
    return ListView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: [
        _mainTitle(),
        const SizedBox(height: 34,),
        _createRequestButton(context, model),
        const SizedBox(height: 34,),
        _pgasRequestsTitle(),
        const SizedBox(height: 31,),
        _pgasRequestsSpace(context, model)
      ],
    );
  }

  _mainTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        "ПГАС",
        style: CyrillicFonts.raleway(
            fontSize: 24,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4065D8)
        ),
      ),
    );
  }

  _createRequestButton(context, PgasViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
      child: Container(
          width: double.maxFinite,
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
              model.goToNewPgasRequest(context);
            },
            child: Text(
              "Подать заявку на ПГАС",
              style: CyrillicFonts.robotoMono(
                fontStyle: FontStyle.normal,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,),
            ),

          )
      ),
    );
  }

  _pgasRequestsTitle() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Ваши заявки",
            style: CyrillicFonts.raleway(
                fontSize: 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4065D8)
            ),
          ),
        ],
      ),
    );
  }

  _pgasRequestsSpace(context, PgasViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: model.pgasList.isEmpty ? Center(
          child: Text(
              "Нет заявок на ПГАС.",
              style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500)
          )) : ListView.builder(
          shrinkWrap: true,
          itemCount: model.pgasList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await model.storage.write(key: "pgas_id", value: model.pgasList[index].requestId.toString());
                model.goToPgasDetail(context);
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Заявка №${model.pgasList[index].requestId}",
                        style: CyrillicFonts.raleway(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),),
                      model.pgasList[index].approveFlag == 1 ? const Icon(Icons.check, color: Colors.green, size: 36,) :
                          const Icon(Icons.access_time_outlined, color: Colors.black, size: 36,)
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Color(0xFF4065D8),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}
