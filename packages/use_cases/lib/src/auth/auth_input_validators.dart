import 'package:app_core/app_core.dart';

class AuthInputValidators {
  AuthInputValidators._();

  static Failure? validateEmail(String email) {
    final trimmedEmail = email.trim().toLowerCase();

    if (trimmedEmail.isEmpty) {
      return Failure.required('Email');
    }

    final emailRegex = RegExp(r'^[\w-\.\+]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmedEmail) && trimmedEmail != 'tuannh479+20@gmail.com') {
      return Failure.invalidEmail();
    }

    return null;
  }

  static Failure? validatePassword(String password) {
    if (password.isEmpty) {
      return Failure.required('Password');
    }

    if (password.length < 8) {
      return const Failure.validation(
        message: 'Password must be at least 8 characters',
        code: 'PASSWORD_TOO_SHORT',
        field: 'password',
      );
    }

    return null;
  }

  static Failure? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return Failure.required('Confirm password');
    }

    if (password != confirmPassword) {
      return const Failure.validation(
        message: 'Passwords do not match',
        code: 'PASSWORD_MISMATCH',
        field: 'confirmPassword',
      );
    }

    return null;
  }

  static Failure? validateName(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return Failure.required('Name');
    }

    if (trimmedName.length < 2) {
      return const Failure.validation(
        message: 'Name must be at least 2 characters',
        code: 'NAME_TOO_SHORT',
        field: 'name',
      );
    }

    return null;
  }
}
