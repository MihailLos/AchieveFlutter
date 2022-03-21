class DetailUnreceivedAchievementModel {
  String? achieveName;
  int? achieveId;
  String? achieveData;
  String? achieveFormat;
  String? achieveCreatorFirstName;
  String? achieveCreatorLastName;
  int? achieveScore;
  String? achieveDescription;

  String? rewardData;
  String? rewardFormat;
  String? rewardName;

  String? categoryData;
  String? categoryFormat;
  String? categoryName;

  String? statusActive;

  DetailUnreceivedAchievementModel({
    this.achieveName,
    this.achieveId,
    this.achieveData,
    this.achieveFormat,
    this.achieveCreatorFirstName,
    this.achieveCreatorLastName,
    this.achieveScore,
    this.achieveDescription,
    this.rewardData,
    this.rewardFormat,
    this.rewardName,
    this.categoryData,
    this.categoryFormat,
    this.categoryName,
    this.statusActive
});

  DetailUnreceivedAchievementModel.fromJson(Map<String, dynamic> json) {
    achieveName = json["achieveName"];
    achieveId = json["achieveId"];
    achieveData = json["file"]["data"];
    achieveFormat = json["file"]["format"];
    achieveCreatorFirstName = json["creator"]["firstName"];
    achieveCreatorLastName = json["creator"]["lastName"];
    achieveScore = json["score"];
    achieveDescription = json["description"];

    rewardData = json["reward"]["file"]["data"];
    rewardFormat = json["reward"]["file"]["format"];
    rewardName = json["reward"]["rewardName"];

    categoryData = json["category"]["file"]["data"];
    categoryFormat = json["category"]["file"]["format"];
    categoryName = json["category"]["categoryName"];

    statusActive = json["statusActive"];
  }
}