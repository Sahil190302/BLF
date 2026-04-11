class MeetingModel {
  final bool status;
  final String message;

  MeetingModel({
    required this.status,
    required this.message,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
