class StreamModel {
  int? streamId;
  String? streamName;

  StreamModel({this.streamId, this.streamName});

  StreamModel.fromJson(Map<String, dynamic> json) {
    streamId = json['streamId'];
    streamName = json['streamName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['streamId'] = this.streamId;
    data['streamName'] = this.streamName;
    return data;
  }
}
