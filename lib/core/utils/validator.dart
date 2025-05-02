import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';

class Validator {
  Validator._();

  static String? phoneNumberValidation(String? number) {
    final RegExp numberRegex = RegExp(
      r'^(\+201|01|00201)[0-2,5]{1}[0-9]{8}$',
    );
    if (number == null || number.trim().isEmpty || number == '+2') {
      return LocaleKeys.validation_phoneEmpty.tr();
    } else if (numberRegex.hasMatch(number) == false) {
      return LocaleKeys.validation_phoneInvalid.tr();
    } else {
      return null;
    }
  }

  static String? passwordValidation(String? password) {
    final RegExp passwordRegex = RegExp(
      r'^(?=.?[A-Z])(?=.?[a-z])(?=.*?[0-9]).{6,}$',
    );
    if (password == null || password.trim().isEmpty) {
      return LocaleKeys.validation_passwordEmpty.tr();
    } else if (passwordRegex.hasMatch(password) == false) {
      return LocaleKeys.validation_passwordInvalid.tr();
    } else {
      return null;
    }
  }

  static String? lastNameValidation(String? name) {
    final RegExp nameRegex = RegExp(
      r'^[a-zA-Z]{2,30}$',
    );
    if (name == null || name.trim().isEmpty) {
      return LocaleKeys.validation_lastNameEmpty.tr();
    } else if (nameRegex.hasMatch(name) == false) {
      return LocaleKeys.validation_lastNameInvalid.tr();
    } else {
      return null;
    }
  }

  static String? firstNameValidation(String? name) {
    final RegExp nameRegex = RegExp(
      r'^[a-zA-Z]{2,30}$',
    );
    if (name == null || name.trim().isEmpty) {
      return LocaleKeys.validation_firstNameEmpty.tr();
    } else if (nameRegex.hasMatch(name) == false) {
      return LocaleKeys.validation_firstNameInvalid.tr();
    } else {
      return null;
    }
  }

  static String? emailValidate(String? email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (email == null || email.trim().isEmpty) {
      return LocaleKeys.validation_emailEmpty.tr();
    } else if (emailRegex.hasMatch(email) == false) {
      return LocaleKeys.validation_emailInvalid.tr();
    } else {
      return null;
    }
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length == 4) {
      return LocaleKeys.validation_pinCodeError.tr();
    }

    return null;
  }

  static String? confirmPasswordValidation(
      String? confirmPassword, String? originalPassword) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return LocaleKeys.validation_confirmPasswordEmpty.tr();
    }
    if (confirmPassword != originalPassword) {
      return LocaleKeys.validation_confirmPasswordMismatch.tr();
    }
    return null;
  }
}
