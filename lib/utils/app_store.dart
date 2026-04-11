import 'package:get/get.dart';

class AppAuthStore extends GetxController {
  // =======================
  // Auth state variables
  // =======================
  RxString _token = "".obs;
  RxString _email = "".obs;
  RxBool _isLoggedIn = false.obs;

  // =======================
  // Getters
  // =======================
  String get token => _token.value;
  String get email => _email.value;
  bool get isLoggedIn => _isLoggedIn.value;

  // =======================
  // Login - save token & email
  // =======================
  void login({required String email, required String token}) {
    _email.value = email;
    _token.value = token;
    _isLoggedIn.value = true;
  }

  // =======================
  // Logout - clear token & email
  // =======================
  void logout() {
    _email.value = "";
    _token.value = "";
    _isLoggedIn.value = false;
  }

  // =======================
  // Helper - check if token exists
  // =======================
  bool get hasToken => _token.isNotEmpty;
}
