import 'package:achieve_student_flutter/screens/achievements/proof_detail_achieve_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          return Scaffold(
            appBar: _appBar(context, model),
            body: _proofAchieveBody(context, model),
          );
        });
  }

  _appBar(context, ProofDetailAchieveViewModel model) {
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

  _proofAchieveBody(context, ProofDetailAchieveViewModel model) {
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
              _achieveName(context, model),
              SizedBox(height: 38,),
              _achieveDescription(context, model),
              SizedBox(height: 12,),
              _achieveStudentDescription(context, model),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _proofDate(context, model),
                  _achieveStatus(context, model)
                ],
              ),
              SizedBox(height: 20,),
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
      style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          fontStyle: FontStyle.normal,
          color: Color(0xFF4065D8)
      ),
    );
  }

  _achieveDescription(context, ProofDetailAchieveViewModel model) {
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
          "${model.proofAchievement!.achieveDescription}",
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

  _achieveStudentDescription(context, ProofDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ваш комментарий к заявке:",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Text(
          "${model.proofAchievement!.proofDescription}",
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

  _proofDate(context, ProofDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Дата заявки:",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Text(
          "${model.proofAchievement!.dateProof}",
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

  _achieveStatus(context, ProofDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Статус рассмотрения:",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Text(
          "${model.proofAchievement!.statusRequestName}",
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

  _moderatorComment(context, ProofDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Комментарий модератора:",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        model.proofAchievement?.comment == null ? Text("") :
        Text(
          "${model.proofAchievement!.comment}",
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
}