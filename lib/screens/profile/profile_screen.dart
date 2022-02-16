import 'package:flutter/material.dart';
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
        builder: (context, model, chile) {
          return Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
            bottomNavigationBar: _bottomNavBar(context, model),
          );
        });
  }

  _appBar(BuildContext context, ProfileViewModel model) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.report,
                color: Colors.blueAccent,
                size: 32,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.login,
                color: Color(0xFFFF9966),
                size: 32,
              ))
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  _body(BuildContext context, ProfileViewModel model) {
    return SafeArea(child: _profile(context, model));
  }

  _bottomNavBar(BuildContext context, ProfileViewModel model) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.school,
            size: 32,
          ),
          label: "Профиль",
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, size: 32), label: "Рейтинг"),
        BottomNavigationBarItem(
            icon: Icon(Icons.star, size: 32), label: "Достижения"),
        BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted, size: 32), label: "Заявки"),
      ],
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.black,
      selectedLabelStyle: Theme.of(context).textTheme.caption,
      unselectedLabelStyle: Theme.of(context).textTheme.caption,
    );
  }

  _profile(BuildContext context, ProfileViewModel model) {
    return Center(
      child: Column(
        children: [
          _profilePicture(context, model),
          _profileName(context, model)
        ],
      ),
    );
  }

  _profilePicture(BuildContext context, ProfileViewModel model) {
    return CircleAvatar(
      backgroundImage: AssetImage("assets/support_image.png"),
      radius: 47.5,
    );
  }

  _profileName(BuildContext context, ProfileViewModel model) {
    return Text(
      "Иван Иванов",
      style: TextStyle(
          fontFamily: "Montseratt",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 17),
    );
  }
}
