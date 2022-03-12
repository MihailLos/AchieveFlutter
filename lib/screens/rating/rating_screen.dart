import 'package:achieve_student_flutter/screens/rating/rating_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class RatingScreenRoute extends MaterialPageRoute {
  RatingScreenRoute() : super(builder: (context) => const RatingScreen());
}

class RatingScreen extends StatelessWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RatingViewModel>.reactive(
        viewModelBuilder: () => RatingViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }

  _appBar(context, model) {
    return AppBar(
      title: Text("Рейтинг студентов",
          style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4065D8))),
      elevation: 0,
      backgroundColor: Colors.transparent,
      // bottom:
    );
  }

  _body(context, model) {
    return Column(
      children: [
        Row(
          children: [
            _searchTextView(context, model),
            IconButton(onPressed: () {model.changeVisibility(context);}, icon: Icon(Icons.filter_alt), color: Colors.blueAccent,)
          ],
        ),
        model.showFilters(context),
        _buttonsTab(context, model),
        model.topStudentsSpace(context)
      ],
    );
  }

  _searchTextView(context, model) {
    return Container(
      width: 300,
      height: 46,
      child: TextField(
        controller: model.searchController,
        onChanged: (value) {
          model.searchAction();
        },
        obscureText: false,
        style: TextStyle(fontFamily: 'OpenSans', fontSize: 14),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
            fillColor: Color(0xfff3f2f2),
            //suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: model.searchAction,),
            filled: true,
            hintText: "Фамилия студента"),
      ),
    );
  }

  _buttonsTab(context, model) {
    return Container(
      child: Row (
        children: [
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  model.fetchStudentsTop10();
                },
                child: Text("Топ-10")
            ),
          ),
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  model.fetchStudentsTop50();
                },
                child: Text("Топ-50")
            ),
          ),
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  model.fetchStudentsTop100();
                },
                child: Text("Топ-100")
            ),
          )
        ],
      ),
    );
  }
}
