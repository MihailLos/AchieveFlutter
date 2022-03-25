class AchieveCategoryModel {
  int? categoryId;
  String? categoryName;
  String? data;
  String? format;

  AchieveCategoryModel(
      {this.categoryId, this.categoryName, this.data, this.format});

  AchieveCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    data = json['data'];
    format = json['format'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['data'] = this.data;
    data['format'] = this.format;
    return data;
  }
}