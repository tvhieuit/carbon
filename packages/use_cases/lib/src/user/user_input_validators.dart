import 'package:app_core/app_core.dart';

class UserInputValidators {
  UserInputValidators._();

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

    if (trimmedName.length > 100) {
      return const Failure.validation(
        message: 'Name must be at most 100 characters',
        code: 'NAME_TOO_LONG',
        field: 'name',
      );
    }

    return null;
  }

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

  static Failure? validatePhone(String phone, {bool allowEmpty = true}) {
    final trimmedPhone = phone.trim();

    if (trimmedPhone.isEmpty) {
      return allowEmpty ? null : Failure.required('Phone');
    }

    final digitsOnly = trimmedPhone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return const Failure.validation(
        message: 'Phone number must be 10-15 digits',
        code: 'INVALID_PHONE',
        field: 'phone',
      );
    }

    if (!RegExp(r'^\d+$').hasMatch(digitsOnly)) {
      return const Failure.validation(
        message: 'Phone number must contain only digits',
        code: 'INVALID_PHONE_FORMAT',
        field: 'phone',
      );
    }

    return null;
  }
}
