class ReferralModel {
  final bool status;
  final String message;

  ReferralModel({
    required this.status,
    required this.message,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      status: json["status"],
      message: json["message"],
    );
  }
}
