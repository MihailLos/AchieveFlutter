class DetailProofAchieveModel {
  String? comment;

  String? achieveData;
  String? achieveFormat;
  String? achieveDescription;
  String? achieveName;
  int? achieveId;

  String? dateProof;
  String? proofDescription;
  int? proofId;

  int? listFileId;

  String? statusRequestName;

  DetailProofAchieveModel({
    this.comment,
    this.achieveData,
    this.achieveFormat,
    this.achieveDescription,
    this.achieveName,
    this.achieveId,
    this.dateProof,
    this.proofDescription,
    this.proofId,
    this.listFileId,
    this.statusRequestName
});

  DetailProofAchieveModel.fromJson(Map<String, dynamic> json) {
    comment = json["comment"];
    achieveData = json["achievement"]["data"];
    achieveFormat = json["achievement"]["format"];
    achieveDescription = json["achievement"]["description"];
    achieveName = json["achievement"]["achieveName"];
    achieveId = json["achievement"]["achieveId"];
    dateProof = json["dateProof"];
    proofDescription = json["description"];
    listFileId = json["listFile"]["listFileId"];
    statusRequestName = json["statusRequestName"];
    proofId = json["proofId"];
  }
}