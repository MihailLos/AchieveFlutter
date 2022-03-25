class CreatedAchievementModel {
  int? achieveId;
  String? achieveName;
  String? data;
  String? format;
  String? statusActive;

  CreatedAchievementModel(
      {this.achieveId,
        this.achieveName,
        this.data,
        this.format,
        this.statusActive});

  CreatedAchievementModel.fromJson(Map<String, dynamic> json) {
    achieveId = json['achieveId'];
    achieveName = json['achieveName'];
    data = json['data'];
    format = json['format'];
    statusActive = json['statusActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['achieveId'] = this.achieveId;
    data['achieveName'] = this.achieveName;
    data['data'] = this.data;
    data['format'] = this.format;
    data['statusActive'] = this.statusActive;
    return data;
  }
}
