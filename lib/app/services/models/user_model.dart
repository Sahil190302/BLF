class LoginModel {
  dynamic status;

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }
}
