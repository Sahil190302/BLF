import 'app_snackbar.dart';

class AppValidator {
  // 🔹 Required Field
  static bool required(String value, String field) {
    if (value.trim().isEmpty) {
      AppSnackbar.error("$field is required");
      return false;
    }
    return true;
  }

  // 🔹 Email Validation
  static bool email(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return false;
    }

    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    return regex.hasMatch(value);
  }

  // 🔹 Phone Validation
  static bool phone(String value, {int length = 10}) {
    value = value.trim();

    if (value.isEmpty) {
      return false;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return false;
    }

    if (value.length != length) {
      return false;
    }

    return true;
  }

  // 🔹 Password Validation
  static bool password(String value, {int minLength = 2}) {
    value = value.trim();

    if (value.isEmpty) {
      return false;
    }

    if (value.length < minLength) {
      return false;
    }

    return true;
  }

  // 🔹 OTP Validation
  static bool otp(String value, {int length = 4}) {
    value = value.trim();

    if (value.isEmpty) {
      return false;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return false;
    }

    if (value.length != length) {
      return false;
    }

    return true;
  }
}