class RewardModel {
  String? data;
  String? format;
  int? rewardId;
  String? rewardName;

  RewardModel({
    this.data,
    this.format,
    this.rewardId,
    this.rewardName
});

  RewardModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    format = json['format'];
    rewardId = json['rewardId'];
    rewardName = json['rewardName'];
  }
}