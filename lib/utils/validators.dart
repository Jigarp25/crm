import 'package:email_validator/email_validator.dart';

class Validators{

  static String? validatePassword(String password) {
    if (password.length < 6) return 'Password must be at least 6 characters';
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Must contain an uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'Must contain a lowercase letter';
    if (!RegExp(r'\d').hasMatch(password)) return 'Must contain a number';
    if (!RegExp(r'[!@#$%^&*?~`.,;:"|]').hasMatch(password)) return 'Must contain a special character';
    return null;
  }

  static String? validateEmail(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Email is required'
          : !EmailValidator.validate(v.trim()) ? 'Enter a valid email'
          : null;

  static String? validateOptionalEmail(String? v) =>
      (v == null || v.trim().isEmpty)
      ? null
      : !EmailValidator.validate(v.trim())
        ? 'Enter a valid email'
          : null;

}

