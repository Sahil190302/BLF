class JoinFormModel {
  final bool? status;
  final int? id;
  final String? apiToken;

  JoinFormModel({
    this.status,
    this.id,
    this.apiToken,
  });

  factory JoinFormModel.fromJson(Map<String, dynamic> json) {
    return JoinFormModel(
      status: json["status"],
      id: json["id"],
      apiToken: json["api_token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "id": id,
      "api_token": apiToken,
    };
  }
}
