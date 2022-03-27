import 'package:achieve_student_flutter/screens/rating/detail_student_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
        builder: (context, model, child) {
          return model.circular
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, model) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_outlined),
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
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: [
        _profilePicture(context, model),
        SizedBox(
          height: 16,
        ),
        _profileName(context, model),
        SizedBox(
          height: 16,
        ),
        _progressField(context, model),
        SizedBox(
          height: 8,
        ),
        _educationInfo(context, model),
      ],
    );
  }

  _profilePicture(context, model) {
    return model.circular
        ? LinearProgressIndicator()
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
                return Center(child: Text("Произошла ошибка"),);
              } else {
                return Center(child: CircularProgressIndicator());
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
            return Center(child: Text("Произошла ошибка"),);
          } else {
            return Center(child: CircularProgressIndicator());
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
        ? LinearProgressIndicator()
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
        Image(image: AssetImage("assets/images/prize_icon.png"))
      ],
    );
  }

  _progressBar(context, model) {
    return model.circular
        ? LinearProgressIndicator()
        : Container(
      height: 29,
      width: 202,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: LinearProgressIndicator(
          backgroundColor: Color(0xFFE2E2E2),
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7CEAF1)),
          value: model.studentPercentProgressBar,
        ),
      ),
    );
  }

  _userPercent(context, model) {
    return model.circular
        ? LinearProgressIndicator()
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
        ? LinearProgressIndicator()
        : Padding(
      padding: const EdgeInsets.fromLTRB(29, 59, 29, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.studentProfileModel!.instituteFullName.toString(), style: CyrillicFonts.raleway(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500)),
          SizedBox(
            height: 5,
          ),
          Text(model.studentProfileModel!.streamFullName.toString(), style: CyrillicFonts.raleway(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500)),
          SizedBox(
            height: 5,
          ),
          Text(model.studentProfileModel!.groupName.toString(), style: CyrillicFonts.raleway(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500)),
          SizedBox(
            height: 5,
          ),
          model.course != null ? Text("${model.course} курс", style: CyrillicFonts.raleway(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500)) :
          Text("Нет курса", style: CyrillicFonts.raleway(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
