class DetailCreatedAchieveModel {
  int? achieveId;
  String? achieveName;
  String? achieveFormat;
  String? achieveData;
  int? achieveScore;
  String? achieveDescription;
  String? achieveStatus;

  String? rewardFormat;
  String? rewardData;
  String? rewardName;

  String? categoryFormat;
  String? categoryData;
  String? categoryName;

  DetailCreatedAchieveModel({
    this.achieveId,
    this.achieveName,
    this.achieveFormat,
    this.achieveData,
    this.achieveScore,
    this.achieveDescription,
    this.achieveStatus,
    this.rewardFormat,
    this.rewardData,
    this.rewardName,
    this.categoryFormat,
    this.categoryData,
    this.categoryName
});

  DetailCreatedAchieveModel.fromJson(Map<String, dynamic> json) {
    achieveDescription = json["description"];
    achieveName = json["achieveName"];
    achieveId = json["achieveId"];
    achieveData = json["file"]["data"];
    achieveFormat = json["file"]["format"];
    achieveScore = json["score"];
    achieveStatus = json["status"];

    rewardName = json["reward"]["rewardName"];
    rewardData = json["reward"]["file"]["data"];
    rewardFormat = json["reward"]["file"]["format"];

    categoryName = json["category"]["categoryName"];
    categoryData = json["category"]["file"]["data"];
    categoryFormat = json["category"]["file"]["format"];
  }
}