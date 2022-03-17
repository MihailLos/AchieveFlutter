class ProofAchieveModel {
  int? achieveId;
  String? achieveName;
  String? achieveData;
  String? achieveDescription;
  String? achieveFormat;
  String? achieveStatusActive;

  String? dateProof;
  int? proofId;
  String? statusRequestName;

  ProofAchieveModel({
    this.achieveId,
    this.achieveName,
    this.achieveData,
    this.achieveDescription,
    this.achieveFormat,
    this.achieveStatusActive,

    this.dateProof,
    this.proofId,
    this.statusRequestName
});

  ProofAchieveModel.fromJson(Map<String, dynamic> json) {
    achieveId = json["achievement"]["achieveId"];
    achieveName = json["achievement"]["achieveName"];
    achieveData = json["achievement"]["data"];
    achieveFormat = json["achievement"]["format"];
    achieveStatusActive = json["achievement"]["statusActive"];

    dateProof = json["dateProof"];
    proofId = json["proofId"];
    statusRequestName = json["statusRequestName"];
  }

}