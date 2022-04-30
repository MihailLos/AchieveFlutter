import 'package:achieve_student_flutter/screens/achievements/proof_achievements/proof_detail_achieve_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

class ProofDetailAchieveScreenRoute extends MaterialPageRoute {
  ProofDetailAchieveScreenRoute()
      : super(builder: (context) => const ProofDetailAchieveScreen());
}

class ProofDetailAchieveScreen extends StatelessWidget {
  const ProofDetailAchieveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProofDetailAchieveViewModel>.reactive(
        viewModelBuilder: () => ProofDetailAchieveViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return model.circle
              ? const Center(
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
                            child: const Icon(Icons.clear)
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
                body: _proofAchieveBody(context, model),
              )
          );
        });
  }

  _proofAchieveBody(context, ProofDetailAchieveViewModel model) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 27, horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _achieveName(context, model),
              const SizedBox(height: 38,),
              _achieveDescription(context, model),
              const SizedBox(height: 12,),
              _achieveStudentDescription(context, model),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _proofDate(context, model),
                  _achieveStatus(context, model)
                ],
              ),
              const SizedBox(height: 20,),
              _moderatorComment(context, model)
            ],
          ),
        )
      ],
    );
  }

  _achieveImage(context, ProofDetailAchieveViewModel model) {
    return Image.memory(
      model.getImage(model.proofAchievement!.achieveData!),
      width: double.maxFinite,
      height: 300,
      fit: BoxFit.cover,
    );
  }

  _achieveName(context, ProofDetailAchieveViewModel model) {
    return Text("${model.proofAchievement?.achieveName}",
      style: CyrillicFonts.raleway(
          fontWeight: FontWeight.w800,
          fontSize: 24,
          fontStyle: FontStyle.normal,
          color: const Color(0xFF4065D8)
      ),
    );
  }

  _achieveDescription(context, ProofDetailAchieveViewModel model) {
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
          "${model.proofAchievement!.achieveDescription}",
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

  _achieveStudentDescription(context, ProofDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ваш комментарий к заявке:",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Text(
          "${model.proofAchievement!.proofDescription}",
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

  _proofDate(context, ProofDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Дата заявки:",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Text(
          "${model.proofAchievement!.dateProof}",
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

  _achieveStatus(context, ProofDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Статус рассмотрения:",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Text(
          "${model.proofAchievement!.statusRequestName}",
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

  _moderatorComment(context, ProofDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Комментарий модератора:",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        model.proofAchievement?.comment == null ? const Text("") :
        Text(
          "${model.proofAchievement!.comment}",
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
}
