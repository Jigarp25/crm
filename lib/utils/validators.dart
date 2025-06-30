import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class Validators{

  static String? validatePassword(String password) {
    if (password.length < 6) return 'Password must be at least 6 characters';
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Must contain an uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'Must contain a lowercase letter';
    if (!RegExp(r'\d').hasMatch(password)) return 'Must contain a number';
    if (!RegExp(r'[!@#$%^&*?~`.,;:"|]').hasMatch(password)) return 'Must contain a special character';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    return isEmail(value.trim()) ? null : 'Enter a valid email';
  }
}
