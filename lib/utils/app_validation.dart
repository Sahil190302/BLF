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

    if (!required(value, "Email")) return false;

    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(value)) {
      AppSnackbar.error("Enter valid email");
      return false;
    }
    return true;
  }

  // 🔹 Phone Validation
  static bool phone(String value, {int length = 10}) {
    value = value.trim();

    if (!required(value, "Phone")) return false;

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      AppSnackbar.error("Phone must be numeric");
      return false;
    }

    if (value.length != length) {
      AppSnackbar.error("Phone must be $length digits");
      return false;
    }

    return true;
  }

  // 🔹 Password Validation
  static bool password(String value, {int minLength = 2}) {
    value = value.trim();

    if (!required(value, "Password")) return false;

    if (value.length < minLength) {
      AppSnackbar.error("Password must be at least $minLength characters");
      return false;
    }

    return true;
  }

  // 🔹 OTP Validation
  static bool otp(String value, {int length = 4}) {
    value = value.trim();

    if (!required(value, "OTP")) return false;

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      AppSnackbar.error("OTP must be numeric");
      return false;
    }

    if (value.length != length) {
      AppSnackbar.error("Please enter valid $length-digit OTP");
      return false;
    }

    return true;
  }
}
