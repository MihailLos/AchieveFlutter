import 'package:achieve_student_flutter/screens/achievements/profile_achievements/created_achieve_grid.dart';
import 'package:achieve_student_flutter/screens/rating/detail_student_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

import '../achievements/profile_achievements/received_achieve_grid.dart';

class DetailStudentScreenRoute extends MaterialPageRoute {
  DetailStudentScreenRoute() : super(builder: (context) => const DetailStudentScreen());
}

class DetailStudentScreen extends StatelessWidget {
  const DetailStudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DetailStudentViewModel>.reactive(
        viewModelBuilder: () => DetailStudentViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        onDispose: (viewModel) => viewModel.onDispose(),
        builder: (context, model, child) {
          return model.circular
              ? const Center(child: CircularProgressIndicator())
              : Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, model) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        color: Colors.black,
        onPressed: () {model.goToRatingScreen(context);},
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
        _profilePicture(context, model),
        const SizedBox(
          height: 16,
        ),
        _profileName(context, model),
        const SizedBox(
          height: 16,
        ),
        _progressField(context, model),
        const SizedBox(
          height: 8,
        ),
        _educationInfo(context, model),
        const SizedBox(
          height: 27,
        ),
        _achievementsTitle(),
        _buttonsSpace(context, model),
        const SizedBox(
          height: 10,
        ),
        model.isCreated ? const CreatedAchieveGridAnotherStudent() : const ReceivedAchieveGridAnotherStudent()
      ],
    );
  }

  _profilePicture(context, model) {
    return model.circular
        ? const LinearProgressIndicator()
        : Align(
      alignment: Alignment.center,
          child: FutureBuilder(
            future: model.getImageFromBase64(),
            builder: (context, snapshot) {
              if (snapshot.hasData || snapshot.data != null) {
                return CircleAvatar(
                    backgroundImage: snapshot.data as ImageProvider,
                    radius: 47.5);
              } else if (snapshot.hasError) {
                return const Center(child: Text("?????????????????? ????????????"),);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
    ),
          );
  }

  _profileName(context, model) {
    return FutureBuilder(
        future: model.getName(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text(
                snapshot.data as String,
                style: CyrillicFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("?????????????????? ????????????"),);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
    );
  }

  _progressField(context, model) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _userScore(context, model),
          _progressBar(context, model),
          _userPercent(context, model)
        ],
      ),
    );
  }

  _userScore(context, model) {
    return model.circular
        ? const LinearProgressIndicator()
        : Row(
      children: [
        Text(
          model.studentProfileModel.score.toString(),
          style: CyrillicFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.blueAccent),
        ),
        const Image(image: AssetImage("assets/images/prize_icon.png"))
      ],
    );
  }

  _progressBar(context, model) {
    return model.circular
        ? const LinearProgressIndicator()
        : Container(
      height: 29,
      width: 202,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: LinearProgressIndicator(
          backgroundColor: const Color(0xFFE2E2E2),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7CEAF1)),
          value: model.studentPercentProgressBar,
        ),
      ),
    );
  }

  _userPercent(context, model) {
    return model.circular
        ? const LinearProgressIndicator()
        : Text(model.studentPercent.toString() + "%",
        style: CyrillicFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          color: Colors.orange,
        ));
  }

  _educationInfo(context, DetailStudentViewModel model) {
    return model.circular
        ? const LinearProgressIndicator()
        : Padding(
      padding: const EdgeInsets.fromLTRB(29, 59, 29, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.studentProfileModel!.instituteFullName.toString(), style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 5,
          ),
          Text(model.studentProfileModel!.streamFullName.toString(), style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 5,
          ),
          Text(model.studentProfileModel!.groupName.toString(), style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 5,
          ),
          model.course != null ? Text("${model.course} ????????", style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500)) :
          Text("?????? ??????????", style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  _buttonsSpace(context, DetailStudentViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          height: 36,
          padding: EdgeInsets.zero,
          decoration: const BoxDecoration(
              color: Color(0xFF39ABDF),
              borderRadius: BorderRadius.all(Radius.circular(180)),
              boxShadow: [
                BoxShadow(
                    color: Color(0xFFFF9966),
                    offset: Offset(0, 3.5),
                    spreadRadius: 1,
                    blurRadius: 7
                )
              ]
          ),
          child: ToggleButtons(
            borderRadius: BorderRadius.circular(180),
            selectedColor: Colors.white,
            color: Colors.white,
            fillColor: const Color(0xFFFF9966),
            renderBorder: false,
            constraints: BoxConstraints.expand(width: (constraints.maxWidth / 2)),
            isSelected: model.isSelectedButton,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("??????????????????????", style: CyrillicFonts.robotoMono(fontSize: 11, fontWeight: FontWeight.w600),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("??????????????????", style: CyrillicFonts.robotoMono(fontSize: 11, fontWeight: FontWeight.w600),),
              ),
            ],
            onPressed: (int newIndex) {
              model.onChangeToggle(newIndex);
            },
          ),
        ),
      ),
    );
  }

  _achievementsTitle() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "????????????????????",
            style: CyrillicFonts.raleway(
                fontSize: 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4065D8)
            ),
          ),
        ],
      ),
    );
  }
}
