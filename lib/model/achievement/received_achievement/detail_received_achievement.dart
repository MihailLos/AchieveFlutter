class DetailReceivedAchieveModel {
  bool? statusReward;
  String? creatorFirstName;
  String? creatorLastName;
  String? achieveData;
  String? achieveFormat;
  int? score;
  String? achieveDescription;
  String? achieveName;
  int? achieveId;
  String? statusActive;
  String? rewardName;
  String? rewardData;
  String? rewardFormat;
  String? categoryName;
  String? categoryData;
  String? categoryFormat;
  int? receivedAchieveId;

  DetailReceivedAchieveModel({
    this.statusReward,
    this.creatorFirstName,
    this.creatorLastName,
    this.achieveData,
    this.achieveFormat,
    this.score,
    this.achieveDescription,
    this.achieveName,
    this.achieveId,
    this.statusActive,
    this.rewardName,
    this.rewardData,
    this.rewardFormat,
    this.categoryName,
    this.categoryData,
    this.categoryFormat,
    this.receivedAchieveId
});

  DetailReceivedAchieveModel.fromJson(Map<String, dynamic> json) {
    statusReward = json["statusReward"];
    creatorFirstName = json["creator"]["firstName"];
    creatorLastName = json["creator"]["lastName"];
    achieveData = json["achievement"]["file"]["data"];
    achieveFormat = json["achievement"]["file"]["format"];
    score = json["achievement"]["score"];
    achieveDescription = json["achievement"]["description"];
    achieveName = json["achievement"]["achieveName"];
    achieveId = json["achievement"]["achieveId"];
    statusActive = json["achievement"]["statusActive"];
    rewardName = json["reward"]["rewardName"];
    rewardData = json["reward"]["file"]["data"];
    rewardFormat = json["reward"]["file"]["format"];
    categoryName = json["category"]["categoryName"];
    categoryData = json["category"]["file"]["data"];
    categoryFormat = json["category"]["file"]["format"];
    receivedAchieveId = json["receivedAchieveId"];
  }
}