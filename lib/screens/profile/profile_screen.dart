import 'package:achieve_student_flutter/screens/achievements/profile_achievements/created_achieve_grid.dart';
import 'package:achieve_student_flutter/screens/achievements/profile_achievements/received_achieve_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          return model.isStudentDataInit && model.isStudyInit && model.isPercentInit
              ? Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          )
              : const Center(child: CircularProgressIndicator(),);
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
          icon: const Icon(Icons.logout, color: Colors.blueAccent,),
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
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          _profilePictureWidget(context, model),
          const SizedBox(
            height: 16,
          ),
          _profileName(context, model),
          const SizedBox(
            height: 16,
          ),
          _progressField(context, model),
          _educationInfo(context, model),
          const SizedBox(
            height: 16,
          ),
          GoToPgasButton(),
          const SizedBox(
            height: 27,
          ),
          AchievementsTitle(),
          _buttonsSpace(context, model),
          const SizedBox(
            height: 10,
          ),
          model.isCreated ? const CreatedAchieveGrid() : const ReceivedAchieveGrid()
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
                              BottomChooseProfilePhotoWidget()));
                    },
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Произошла ошибка"),);
          } else {
            return const Center(child: CircularProgressIndicator());
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
          return const Center(child: Text("Произошла ошибка"),);
        } else {
          return const Center(child: CircularProgressIndicator());
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
                BottomChooseProfilePhotoWidget()));
      },
      child: _buildCircle(
        const Icon(
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
        padding: const EdgeInsets.all(5),
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
    return Row(
            children: [
              Text(
                model.studentProfileModel.score.toString(),
                style: CyrillicFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: const Color(0xFF4065D8)),
              ),
              const Image(image: AssetImage("assets/images/prize_icon.png"))
            ],
          );
  }

  _progressBar(context, model) {
    return SizedBox(
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
    return Text(model.studentPercent.toString() + "%",
            style: CyrillicFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.orange,
            ));
  }

  _educationInfo(context, ProfileViewModel model) {
    return Padding(
            padding: const EdgeInsets.fromLTRB(29, 59, 29, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: model.getInstitute(),
                    builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data as String, style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Произошла ошибка"),);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                    },
                ),
                const SizedBox(
                  height: 5,
                ),
                FutureBuilder(
                  future: model.getStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data as String, style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Произошла ошибка"),);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                FutureBuilder(
                  future: model.getGroup(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data as String, style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Произошла ошибка"),);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                model.course != null ? Text("${model.course} курс", style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500)) :
                Text("Нет курса", style: CyrillicFonts.raleway(fontSize: 12, color: const Color(0xFF757575), fontWeight: FontWeight.w500))
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
}

class GoToPgasButton extends StatelessWidget {
  const GoToPgasButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileViewModel model = ProfileViewModel(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
      child: Container(
          width: double.maxFinite,
          height: 30,
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

class AchievementsTitle extends StatelessWidget {
  const AchievementsTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                color: const Color(0xFF4065D8)
            ),
          ),
        ],
      ),
    );
  }
}

class BottomChooseProfilePhotoWidget extends StatelessWidget {
  const BottomChooseProfilePhotoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileViewModel model = ProfileViewModel(context);
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Text(
              "Изменить фото профиля",
              style: CyrillicFonts.raleway(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF5878DD)
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Если фото будет содержать непристойный контент, ваш аккаунт будет заблокирован модератором!",
              style: CyrillicFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF757575)
              ),
            ),
            const SizedBox(
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
                          padding: const EdgeInsets.all(10),
                          color: const Color(0xFFFF9966),
                          child: const Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),
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
                          padding: const EdgeInsets.all(10),
                          color: const Color(0xFFFF9966),
                          child: const Icon(
                            Icons.photo,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),
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
}
