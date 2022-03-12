import 'package:achieve_student_flutter/screens/achievements/created_achieve_grid.dart';
import 'package:achieve_student_flutter/screens/achievements/received_achieve_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          icon: Icon(Icons.refresh, color: Color(0xFFFF9966),),
          onPressed: () => model.refresh(),
          iconSize: 32,
        ),
        IconButton(
          icon: Image.asset("assets/images/exit_button.png"),
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
          SizedBox(
            height: 8,
          ),
          _educationInfo(context, model),
          SizedBox(
            height: 27,
          ),
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
              style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
    return _buildCircle(
      Icon(
        Icons.edit,
        size: 20,
        color: Colors.white,
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
                FutureBuilder(
                  future: model.getInstitute(),
                    builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data as String);
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
                      return Text(snapshot.data as String);
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
                      return Text(snapshot.data as String);
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Произошла ошибка"),);
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          );
  }

  _buttonsSpace(context, model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(onPressed: () {model.showCreatedAchieve();}, child: Text("Созданные")),
        ElevatedButton(onPressed: () {model.showReceivedAchieve();}, child: Text("Полученные")),
      ],
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
                InkWell(
                  onTap: () {
                    model.pickImage(ImageSource.camera, context);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.camera_alt),
                            Text("Камера")
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    model.pickImage(ImageSource.gallery, context);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.photo),
                            Text("Выбрать из галереи")
                          ],
                        ),
                      ),
                    ),
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
