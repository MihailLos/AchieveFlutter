class UnreceivedAchievementModel {
  int? achieveId;
  String? achieveName;
  String? achieveData;
  String? achieveDescription;
  String? achieveFormat;

  String? categoryName;
  String? categoryData;
  String? categoryFormat;

  String? rewardData;
  String? rewardFormat;
  String? rewardId;

  int? score;

  UnreceivedAchievementModel({
    this.achieveId,
    this.achieveName,
    this.achieveData,
    this.achieveDescription,
    this.achieveFormat,

    this.categoryName,
    this.categoryData,
    this.categoryFormat,

    this.rewardData,
    this.rewardFormat,
    this.rewardId,

    this.score
  });

  UnreceivedAchievementModel.fromJson(Map<String, dynamic> json) {
    achieveId = json["achieveId"];
    achieveName = json["achieveName"];
    achieveData = json["file"]["data"];
    achieveDescription = json["description"];
    achieveFormat = json["file"]["format"];

    categoryName = json["category"]["categoryName"];
    categoryData = json["category"]["file"]["data"];
    categoryFormat = json["category"]["file"]["format"];

    rewardData = json["reward"]["file"]["data"];
    rewardFormat = json["reward"]["file"]["format"];
    rewardId = json["reward"]["rewardId"];

    score = json["score"];
  }

}