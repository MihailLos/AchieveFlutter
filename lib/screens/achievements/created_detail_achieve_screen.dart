import 'package:achieve_student_flutter/screens/achievements/created_detail_achieve_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class CreatedDetailAchieveScreenRoute extends MaterialPageRoute {
  CreatedDetailAchieveScreenRoute()
      : super(builder: (context) => const CreatedDetailAchieveScreen());
}

class CreatedDetailAchieveScreen extends StatelessWidget {
  const CreatedDetailAchieveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreatedDetailAchieveViewModel>.reactive(
        viewModelBuilder: () => CreatedDetailAchieveViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: _appBar(context, model),
            body: _createdAchieveBody(context, model),
          );
        });
  }

  _appBar(context, CreatedDetailAchieveViewModel model) {
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

  _createdAchieveBody(context, CreatedDetailAchieveViewModel model) {
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
              _achieveReward(context, model),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _achieveCategory(context, model),
                  SizedBox(width: 84,),
                  _achieveStatus(context, model)
                ],
              ),
              SizedBox(height: 20,),
              model.createdAchievement?.achieveStatus != "Активно" ?
              Text("На неактивные достижения нельзя подавать заявку на получение.",
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontSize: 14
                )
              ) :
              _createProofPlace(context, model)
            ],
          ),
        )
      ],
    );
  }

  _achieveImage(context, CreatedDetailAchieveViewModel model) {
    return Image.memory(
      model.getImage(model.createdAchievement!.achieveData!),
      width: double.maxFinite,
      height: 300,
      fit: BoxFit.cover,
    );
  }

  _achieveName(context, CreatedDetailAchieveViewModel model) {
    return Text("${model.createdAchievement?.achieveName}",
      style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          fontStyle: FontStyle.normal,
          color: Color(0xFF4065D8)
      ),
    );
  }

  _achieveDescription(context, CreatedDetailAchieveViewModel model) {
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
          "${model.createdAchievement!.achieveDescription}",
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

  _achieveReward(context, CreatedDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Награда:",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Row(
          children: [
            Image.memory(model.getImage(model.createdAchievement!.rewardData.toString()), width: 24, height: 24,),
            Text(
              "${model.createdAchievement!.rewardName}",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 14
              ),
            )
          ],
        )
      ],
    );
  }

  _achieveCategory(context, CreatedDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Категория:",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Row(
          children: [
            Image.memory(model.getImage(model.createdAchievement!.categoryData.toString()), width: 24, height: 24,),
            Text(
              "${model.createdAchievement!.categoryName}",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 14
              ),
            )
          ],
        )
      ],
    );
  }

  _achieveStatus(context, CreatedDetailAchieveViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Статус:",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Text(
          "${model.createdAchievement!.achieveStatus}",
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

  _createProofPlace(context, CreatedDetailAchieveViewModel model) {
    return Column(
      children: [
        _proofAchieveRule(context),
        SizedBox(height: 16,),
        _commentProofAchieve(context, model),
        SizedBox(height: 16,),
        _chooseFilesButton(context, model),
        SizedBox(height: 16,),
        _filesListView(context, model),
        _sendButton(context, model)
      ],
    );
  }

  _proofAchieveRule(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Правила получения:",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Text(
          "Для получения достижения прикрепите файлы "
              "(предпочтительны форматы pdf, jpg, png), "
              "подтверждающие выполнение его условий, "
              "представленных в описании к достижению и напишите комментарий с "
              "причиной, почему, на ваш взгляд, вы должны получить это "
              "достижение. Ваша заявка будет "
              "рассмотрена модератором. Статус заявки на получение можно "
              "отслеживать во вкладке 'Подтверждение', на странице 'Заявки'",
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

  _commentProofAchieve(context, CreatedDetailAchieveViewModel model) {
    return Container(
      width: double.maxFinite,
      height: 46,
      child: TextField(
        controller: model.commentController,
        obscureText: false,
        style: TextStyle(fontFamily: 'OpenSans', fontSize: 14),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFC4C4C4), width: 1)),
            fillColor: Colors.transparent,
            filled: true,
            hintText: "Комментарий к заявке"),
      ),
    );
  }

  _chooseFilesButton(context, CreatedDetailAchieveViewModel model) {
    return Container(
        width: double.maxFinite,
        height: 46,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xFF4065D8),
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(0, 4)),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            model.chooseFilesAction(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.file_download),
              Text(
                "Выбрать файлы",
                style: TextStyle(
                    fontFamily: "Montseratt",
                    fontStyle: FontStyle.normal,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            primary: Color(0xFF4065D8),
          ),
        )
    );
  }

  _filesListView(context, CreatedDetailAchieveViewModel model) {
    return model.filePickerResult == null ?
    Text("Здесь будут отображены загружаемые вами файлы") :
    Container(
      height: 150,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: model.filePickerResult?.files.length,
          itemBuilder: (context, index) {
            final file = model.filePickerResult!.files[index];
            double fileSize = file.size / 1024 / 1024;
            double fileSizeRounded = double.parse(fileSize.toStringAsFixed(2));
            String fileSizeString = "$fileSizeRounded MB";
            return InkWell(
              onTap: () {
                model.openFiles(file);
              },
              child: Container(
                width: 120,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Color(0xFF4065D8),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Text(
                        ".${file.extension}",
                        style: GoogleFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                    Text(
                      file.name,
                      style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      fileSizeString,
                      style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  _sendButton(context, CreatedDetailAchieveViewModel model) {
    return Container(
        width: double.maxFinite,
        height: 46,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey,
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(0, 4)),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            model.sendButtonAction(context);
          },
          child: Text(
            "Отправить заявку",
            style: TextStyle(
                fontFamily: "Montseratt",
                fontStyle: FontStyle.normal,
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            primary: Color(0xFFFF9966),
          ),
        )
    );
  }
}