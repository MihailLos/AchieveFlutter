import 'package:achieve_student_flutter/screens/achievements/profile_achievements/created_achieve_grid.dart';
import 'package:achieve_student_flutter/screens/achievements/profile_achievements/received_achieve_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'profile_viewmodel.dart';

class ProfileScreenRoute extends MaterialPageRoute {
  ProfileScreenRoute() : super(builder: (context) => const ProfileScreen());
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return model.circular
              ? Center(child: CircularProgressIndicator(),)
              : Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, model) {
    return AppBar(
      leading: IconButton(
        icon: Image.asset("assets/images/support_button.png"),
        onPressed: () async {
          model.goToReportsScreen(context);
        },
        iconSize: 32,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          icon: Icon(Icons.logout, color: Colors.blueAccent,),
          onPressed: () => model.exitButtonAction(context),
          iconSize: 32,
        ),
      ],
    );
  }

  _body(context, model) {
    return RefreshIndicator(
      onRefresh: model.refresh,
      child: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          _profilePictureWidget(context, model),
          SizedBox(
            height: 16,
          ),
          _profileName(context, model),
          SizedBox(
            height: 16,
          ),
          _progressField(context, model),
          _educationInfo(context, model),
          SizedBox(
            height: 16,
          ),
          _goToPgasButton(context, model),
          SizedBox(
            height: 27,
          ),
          _achievementsTitle(),
          _buttonsSpace(context, model),
          SizedBox(
            height: 10,
          ),
          model.isCreated ? CreatedAchieveGrid() : ReceivedAchieveGrid()
        ],
      ),
    );
  }

  _profilePictureWidget(context, model) {
    return Center(
      child: Stack(
        children: [
          _profilePicture(context, model),
          Positioned(
            child: _editProfilePictureButton(context, model),
            bottom: 0,
            right: 4,
          )
        ],
      ),
    );
  }

  _profilePicture(context, model) {
    return FutureBuilder(
        future: model.getImageFromBase64(),
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.data != null) {
            return ClipOval(
              child: Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: snapshot.data as ImageProvider,
                  fit: BoxFit.cover,
                  width: 95,
                  height: 95,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: ((builder) =>
                              _bottomChooseProfilePhotoWidget(context, model)));
                    },
                  ),
                ),
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

  _editProfilePictureButton(context, model) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: ((builder) =>
                _bottomChooseProfilePhotoWidget(context, model)));
      },
      child: _buildCircle(
        Icon(
          Icons.edit,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  _buildCircle(Widget child) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(5),
        color: Colors.blueAccent,
        child: child,
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
                style: CyrillicFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Color(0xFF4065D8)),
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

  _educationInfo(context, ProfileViewModel model) {
    return model.circular
        ? LinearProgressIndicator()
        : Padding(
            padding: const EdgeInsets.fromLTRB(29, 59, 29, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: model.getInstitute(),
                    builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data as String, style: CyrillicFonts.raleway(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Произошла ошибка"),);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                    },
                ),
                SizedBox(
                  height: 5,
                ),
                FutureBuilder(
                  future: model.getStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data as String, style: CyrillicFonts.raleway(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500));
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Произошла ошибка"),);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                FutureBuilder(
                  future: model.getGroup(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data as String, style: CyrillicFonts.raleway(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500));
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Произошла ошибка"),);
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                model.course != null ? Text("${model.course} курс", style: CyrillicFonts.raleway(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500)) :
                Text("Нет курса", style: CyrillicFonts.raleway(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500))
              ],
            ),
          );
  }

  _buttonsSpace(context, ProfileViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          height: 36,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
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
              fillColor: Color(0xFFFF9966),
              renderBorder: false,
              constraints: BoxConstraints.expand(width: (constraints.maxWidth / 2)),
              isSelected: model.isSelectedButton,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Выполненные", style: CyrillicFonts.robotoMono(fontSize: 11, fontWeight: FontWeight.w600),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Созданные", style: CyrillicFonts.robotoMono(fontSize: 11, fontWeight: FontWeight.w600),),
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

  _bottomChooseProfilePhotoWidget(context, model) {
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Text(
              "Изменить фото профиля",
              style: CyrillicFonts.raleway(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF5878DD)
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Если фото будет содержать непристойный контент, ваш аккаунт будет заблокирован модератором!",
              style: CyrillicFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF757575)
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    model.pickImage(ImageSource.camera, context);
                  },
                  child: Column(
                    children: [
                      ClipOval(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Color(0xFFFF9966),
                          child: Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                          "Камера",
                          style: CyrillicFonts.raleway(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    model.pickImage(ImageSource.gallery, context);
                  },
                  child: Column(
                    children: [
                      ClipOval(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Color(0xFFFF9966),
                          child: Icon(
                            Icons.photo,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                          "Галерея",
                          style: CyrillicFonts.raleway(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )
                      )
                    ],
                  ),
                )
              ],
            )
          ],
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
            "Ваши достижения",
            style: CyrillicFonts.raleway(
                fontSize: 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4065D8)
            ),
          ),
        ],
      ),
    );
  }

  _goToPgasButton(context, ProfileViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
      child: Container(
          width: double.maxFinite,
          height: 30,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0, 6),
                  spreadRadius: 1,
                  blurRadius: 7
              )
            ],
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
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
              model.goToPgasScreen(context);
            },
            child: Text(
              "Мои заявки на ПГАС",
              style: CyrillicFonts.raleway(
                fontStyle: FontStyle.normal,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,),
            ),

          )
      ),
    );
  }
}
