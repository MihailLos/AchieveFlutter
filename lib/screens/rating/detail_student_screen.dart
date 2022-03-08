import 'package:achieve_student_flutter/screens/rating/detail_student_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

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
              ? LinearProgressIndicator()
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
        SizedBox(
          height: 27,
        ),
        // _achievementsTabs(context, model)
      ],
    );
  }

  _profilePicture(context, model) {
    return model.circular
        ? LinearProgressIndicator()
        : Align(
      alignment: Alignment.center,
          child: CircleAvatar(
      backgroundImage: model.getImageFromBase64(model.studentProfileModel.data.toString()),
      radius: 47.5,
    ),
        );
  }

  _profileName(context, model) {
    return model.circular
        ? LinearProgressIndicator()
        : Center(
      child: Text(
        model.studentProfileModel.firstName +
            " " +
            model.studentProfileModel.lastName,
        style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal),
      ),
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
          style: GoogleFonts.montserrat(
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
        : SizedBox(
      height: 29,
      width: 202,
      child: LinearProgressIndicator(
        value: model.studentPercentProgressBar,
      ),
    );
  }

  _userPercent(context, model) {
    return model.circular
        ? LinearProgressIndicator()
        : Text(model.studentPercent.toString() + "%",
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          color: Colors.orange,
        ));
  }

  _educationInfo(context, model) {
    return model.circular
        ? LinearProgressIndicator()
        : Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 29),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.studentProfileModel.instituteFullName),
          SizedBox(
            height: 5,
          ),
          Text(model.studentProfileModel.streamFullName),
          SizedBox(
            height: 5,
          ),
          Text(model.studentProfileModel.groupName),
        ],
      ),
    );
  }

  _bottomChooseProfilePhotoWidget(context, model) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Text(
              "Изменить фото профиля",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Если фото будет содержать непристойный контент, Ваш аккаунт будет заблокирован модератором!",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {model.pickPhoto(ImageSource.camera);},
                      icon: Icon(Icons.camera_alt_outlined),
                      iconSize: 40,
                    ),
                    Text("Камера", style: TextStyle(fontSize: 14),)
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {model.pickPhoto(ImageSource.gallery);},
                      icon: Icon(Icons.image_outlined),
                      iconSize: 40,
                    ),
                    Text("Галерея", style: TextStyle(fontSize: 14),)
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
