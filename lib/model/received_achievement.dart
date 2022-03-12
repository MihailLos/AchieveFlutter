class ReceivedAchievementModel {
  int? achieveId;
  String? achieveName;
  String? achieveData;
  String? achieveDescription;
  String? achieveFormat;
  String? achieveStatusActive;

  int? categoryId;
  String? categoryName;
  String? categoryData;
  String? categoryFormat;

  int? receivedAchieveId;

  String? rewardData;
  String? rewardFormat;
  int? rewardId;
  String? rewardName;

  bool? statusReward;

  ReceivedAchievementModel({
    this.achieveId,
    this.achieveName,
    this.achieveData,
    this.achieveDescription,
    this.achieveFormat,
    this.achieveStatusActive,

    this.categoryId,
    this.categoryName,
    this.categoryData,
    this.categoryFormat,

    this.receivedAchieveId,

    this.rewardData,
    this.rewardFormat,
    this.rewardId,
    this.rewardName,

    this.statusReward,
});

  ReceivedAchievementModel.fromJson(Map<String, dynamic> json) {
    achieveId = json["achievement"]["achieveId"];
    achieveName = json["achievement"]["achieveName"];
    achieveData = json["achievement"]["file"]["data"];
    achieveDescription = json["achievement"]["description"];
    achieveFormat = json["achievement"]["file"]["format"];
    achieveStatusActive = json["achievement"]["statusActive"];

    categoryId = json["category"]["categoryId"];
    categoryName = json["category"]["categoryName"];
    categoryData = json["category"]["file"]["data"];
    categoryFormat = json["category"]["file"]["format"];

    receivedAchieveId = json["receivedAchieveId"];

    rewardData = json["reward"]["file"]["data"];
    rewardFormat = json["reward"]["file"]["format"];
    rewardId = json["reward"]["rewardId"];
    rewardName = json["reward"]["rewardName"];

    statusReward = json["statusReward"];
  }

}