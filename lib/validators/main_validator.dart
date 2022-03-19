import 'package:email_validator/email_validator.dart';

class MainValidator {
  static String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    } else if (!EmailValidator.validate(value)) {
      return 'Enter an correct email';
    } else {
      return null;
    }
  }

  static String? simpleValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  static String? confirmPasswordValidation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    } else if (value != password) {
      return 'Confirm password isn\'t equal';
    }
    return null;
  }
}
