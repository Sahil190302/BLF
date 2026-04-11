class ForgetPasswordModel {
  dynamic status;

  ForgetPasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }
}
