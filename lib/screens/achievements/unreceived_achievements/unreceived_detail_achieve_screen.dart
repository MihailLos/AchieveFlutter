import 'package:achieve_student_flutter/screens/achievements/unreceived_achievements/unreceived_detail_achieve_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:stacked/stacked.dart';

class UnreceivedDetailAchievementScreenRoute extends MaterialPageRoute {
  UnreceivedDetailAchievementScreenRoute()
      : super(builder: (context) => const UnreceivedDetailAchievementScreen());
}

class UnreceivedDetailAchievementScreen extends StatelessWidget {
  const UnreceivedDetailAchievementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UnreceivedDetailAchievementViewModel>.reactive(
        viewModelBuilder: () => UnreceivedDetailAchievementViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return model.circle
              ? const Center(
            child: CircularProgressIndicator(),
          )
              :  Scaffold(
            extendBodyBehindAppBar: true,
              body: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) =>
                [
                  SliverAppBar(
                    expandedHeight: 350,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _achieveImage(context, model),
                    ),
                    leading: IconButton(
                      icon: ClipOval(
                        child: Container(
                            width: 64,
                            height: 64,
                            color: Colors.grey.withOpacity(0.25),
                            child: const Icon(Icons.clear)
                        ),
                      ),
                      color: Colors.black,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      iconSize: 32,
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  )
                ],
                body: model.unreceivedAchievement?.statusActive == "??????????????"
                    ? _activeAchieveBody(context, model)
                    : _nonActiveAchieveBody(context, model),
              )
          );
        });
  }



  _activeAchieveBody(context, UnreceivedDetailAchievementViewModel model) {
    return ListView(
      children: [
        //_achieveImage(context, model),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 27, horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _authorName(context, model),
              const SizedBox(height: 8,),
              _achieveName(context, model),
              const SizedBox(height: 38,),
              _achieveDescription(context, model),
              const SizedBox(height: 12,),
              _achieveReward(context, model),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _achieveCategory(context, model),
                  const SizedBox(width: 84,),
                  _achieveStatus(context, model)
                ],
              ),
              const SizedBox(height: 20,),
              _proofAchieveRule(context),
              const SizedBox(height: 16,),
              _commentProofAchieve(context, model),
              const SizedBox(height: 16,),
              _chooseFilesButton(context, model),
              const SizedBox(height: 16,),
              _filesListView(context, model),
              _sendButton(context, model)
            ],
          ),
        )
      ],
    );
  }

  _nonActiveAchieveBody(context, UnreceivedDetailAchievementViewModel model) {
    return ListView(
      children: [
        //_achieveImage(context, model),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 27, horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _authorName(context, model),
              const SizedBox(height: 8,),
              _achieveName(context, model),
              const SizedBox(height: 38,),
              _achieveDescription(context, model),
              const SizedBox(height: 12,),
              _achieveReward(context, model),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _achieveCategory(context, model),
                  const SizedBox(width: 84,),
                  _achieveStatus(context, model)
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  _achieveImage(context, UnreceivedDetailAchievementViewModel model) {
    return Image.memory(
      model.getImage(model.unreceivedAchievement!.achieveData.toString()),
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  _authorName(context, UnreceivedDetailAchievementViewModel model) {
    return Text(
      "??????????: ${model.unreceivedAchievement?.achieveCreatorFirstName} ${model
          .unreceivedAchievement?.achieveCreatorLastName}",
      style: CyrillicFonts.raleway(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          color: Colors.grey,
          fontSize: 14
      ),
    );
  }

  _achieveName(context, UnreceivedDetailAchievementViewModel model) {
    return Text("${model.unreceivedAchievement?.achieveName}",
      style: CyrillicFonts.raleway(
          fontWeight: FontWeight.w800,
          fontSize: 24,
          fontStyle: FontStyle.normal,
          color: const Color(0xFF4065D8)
      ),
    );
  }

  _achieveDescription(context, UnreceivedDetailAchievementViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("????????????????:",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Text(
          "${model.unreceivedAchievement!.achieveDescription}",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        )
      ],
    );
  }

  _achieveReward(context, UnreceivedDetailAchievementViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("??????????????:",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Row(
          children: [
            Image.memory(model.getImage(
                model.unreceivedAchievement!.rewardData.toString()), width: 24,
              height: 24,),
            Text(
              "${model.unreceivedAchievement!.rewardName}",
              style: CyrillicFonts.raleway(
                  fontWeight: FontWeight.w400,
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

  _achieveCategory(context, UnreceivedDetailAchievementViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("??????????????????:",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Row(
          children: [
            Image.memory(model.getImage(
                model.unreceivedAchievement!.categoryData.toString()),
              width: 24, height: 24,),
            Text(
              "${model.unreceivedAchievement!.categoryName}",
              style: CyrillicFonts.raleway(
                  fontWeight: FontWeight.w400,
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

  _achieveStatus(context, UnreceivedDetailAchievementViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("????????????:",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Row(
          children: [
            model.unreceivedAchievement!.statusActive.toString() == "??????????????" ?
            const Icon(Icons.check, color: Colors.green, size: 24,) :
            model.unreceivedAchievement!.statusActive.toString() == "???? ??????????????"
                ?
            const Icon(Icons.access_time, color: Colors.black, size: 24,)
                :
            const Icon(Icons.close, color: Colors.red, size: 24,),
            Text(
              "${model.unreceivedAchievement!.statusActive}",
              style: CyrillicFonts.raleway(
                  fontWeight: FontWeight.w400,
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

  _proofAchieveRule(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("?????????????? ??????????????????:",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
        Text(
          "?????? ?????????????????? ???????????????????? ???????????????????? ?????????? "
              "(?????????????????????????????? ?????????????? pdf, jpg, png), "
              "???????????????????????????? ???????????????????? ?????? ??????????????, "
              "???????????????????????????? ?? ???????????????? ?? ???????????????????? ?? ???????????????? ?????????????????????? ?? "
              "????????????????, ????????????, ???? ?????? ????????????, ???? ???????????? ???????????????? ?????? "
              "????????????????????. ???????? ???????????? ?????????? "
              "?????????????????????? ??????????????????????. ???????????? ???????????? ???? ?????????????????? ?????????? "
              "?????????????????????? ???? ?????????????? '??????????????????????????', ???? ???????????????? '????????????'",
          style: CyrillicFonts.raleway(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 14
          ),
        )
      ],
    );
  }

  _commentProofAchieve(context, UnreceivedDetailAchievementViewModel model) {
    return SingleChildScrollView(
      reverse: true,
      child: SizedBox(
        width: double.maxFinite,
        height: 46,
        child: TextField(
          controller: model.commentController,
          obscureText: false,
          style: const TextStyle(fontFamily: 'OpenSans', fontSize: 14),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFC4C4C4), width: 1)),
              fillColor: Colors.transparent,
              filled: true,
              hintText: "?????????????????????? ?? ????????????"),
        ),
      ),
    );
  }

  _chooseFilesButton(context, UnreceivedDetailAchievementViewModel model) {
    return SizedBox(
        width: double.maxFinite,
        height: 46,
        child: OutlinedButton(
          onPressed: () {
            model.chooseFilesAction(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.file_download, color: Colors.black,),
              Text(
                "?????????????? ??????????",
                style: CyrillicFonts.raleway(
                    fontStyle: FontStyle.normal,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ],
          ),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        )
    );
  }

  _filesListView(context, UnreceivedDetailAchievementViewModel model) {
    return model.filePickerResult == null ?
    const Text("") :
    SizedBox(
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
              child: SizedBox(
                width: 120,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: file.extension == "docx" ||
                              file.extension == "doc" ? Colors.blue :
                          file.extension == "jpg" || file.extension == "png"
                              || file.extension == "png" ? Colors.green
                              : file.extension == "pdf" ? Colors.red :
                          const Color(0xFF4065D8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: file.extension == "docx" ||
                                    file.extension == "doc"
                                    ? Colors.blueAccent
                                    :
                                file.extension == "jpg" ||
                                    file.extension == "png"
                                    || file.extension == "png" ? Colors
                                    .greenAccent
                                    : file.extension == "pdf"
                                    ? Colors.redAccent
                                    :
                                const Color(0xFF4065D8),
                                offset: const Offset(3, 3.5),
                                spreadRadius: 1,
                                blurRadius: 7
                            )
                          ]
                      ),
                      child: Text(
                        ".${file.extension}",
                        style: CyrillicFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                    Text(
                      file.name,
                      style: CyrillicFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      fileSizeString,
                      style: CyrillicFonts.montserrat(
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

  _sendButton(context, UnreceivedDetailAchievementViewModel model) {
    return Container(
        width: double.maxFinite,
        height: 46,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 6),
                spreadRadius: 1,
                blurRadius: 7
            )
          ],
          borderRadius: BorderRadius.circular(10),
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
            model.sendButtonAction(context);
          },
          child: Text(
            "?????????????????? ????????????",
            style: CyrillicFonts.raleway(
              fontStyle: FontStyle.normal,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,),
          ),

        )
    );
  }
}