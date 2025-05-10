// core/utils/validator.dart
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

  //---------------------------------------------------------phone number

  static String formatPhoneNumber(String? phone, String? countryCode) {
    if (phone == null || phone.isEmpty) return '';

    String cleanedPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');

    if (countryCode == 'EG' || countryCode == '+20') {
      if (cleanedPhone.startsWith('0')) {
        cleanedPhone = '+20${cleanedPhone.substring(1)}';
      } else if (cleanedPhone.startsWith('00')) {
        cleanedPhone = '+${cleanedPhone.substring(2)}';
      } else if (!cleanedPhone.startsWith('+')) {
        cleanedPhone = '+20$cleanedPhone';
      }
    } else {
      if (!cleanedPhone.startsWith('+')) {
        if (countryCode != null && countryCode.isNotEmpty) {
          String formattedCountryCode =
              countryCode.startsWith('+') ? countryCode : '+$countryCode';
          cleanedPhone = '$formattedCountryCode$cleanedPhone';
        }
      }
    }
    return cleanedPhone;
  }

  static String formatPhoneForApi(String? phone) {
    if (phone == null || phone.isEmpty) return '';

    if (phone.startsWith('01')) {
      String result = phone.substring(1);
      return result;
    }

    if (phone.length >= 9 && phone.length <= 15) {
      String result = phone.replaceAll(RegExp(r'[^0-9]'), '');
      return result;
    }
    String result = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return result;
  }

//---------------------------------------------------------vehicle number
  static String? validateVehicleNumber(String? vehicleNumber) {
    final RegExp vehicleNumberRegex = RegExp(
      r'^[A-Z]{2}[ -][0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)? [0-9]{4}$',
    );
    if (vehicleNumber == null || vehicleNumber.trim().isEmpty) {
      return LocaleKeys.validation_required.tr();
    } else if (vehicleNumberRegex.hasMatch(vehicleNumber) == false) {
      return LocaleKeys.validation_vehicleNumber.tr();
    } else {
      return null;
    }
  }

  //---------------------------------------------------------vehicle license

  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validation_required.tr();
    }
    return null;
  }

//----------------------------------------------------------vehicle type
  static String? validateObjectId(String? str) {
    if (str == null || str.isEmpty) {
      return LocaleKeys.validation_required.tr();
    }

    if (str.length != 24) {
      return 'Vehicle type ID must be exactly 24 characters';
    }

    final RegExp hexRegExp = RegExp(r'^[0-9a-fA-F]{24}$');
    if (!hexRegExp.hasMatch(str)) {
      return 'Vehicle type ID must only contain hexadecimal characters';
    }

    return null;
  }

//--------------------------------------------------------national id
  static bool isValidObjectId(String? str) {
    if (str == null || str.length != 24) return false;

    final RegExp hexRegExp = RegExp(r'^[0-9a-fA-F]{24}$');
    return hexRegExp.hasMatch(str);
  }

  static String? validateNationalID(String? nid) {
    if (nid == null || nid.isEmpty) {
      return LocaleKeys.validation_required.tr();
    }

    String digitsOnly = nid.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length != 14) {
      return 'National ID must be exactly 14 digits';
    }

    if (!['2', '3'].contains(digitsOnly[0])) {
      return 'National ID must start with 2 or 3';
    }

    try {
      int year = int.parse(digitsOnly.substring(1, 3));
      int month = int.parse(digitsOnly.substring(3, 5));
      int day = int.parse(digitsOnly.substring(5, 7));

      // Basic date validation
      if (month < 1 || month > 12) {
        return 'National ID contains invalid month';
      }
      if (day < 1 || day > 31) {
        return 'National ID contains invalid day';
      }
    } catch (e) {
      return 'National ID has invalid date format';
    }

    return null;
  }

  static String formatNationalID(String? nid) {
    if (nid == null || nid.isEmpty) return '00000000000000';

    String digitsOnly = nid.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length == 14) {
      return digitsOnly;
    } else if (digitsOnly.length < 14) {
      return digitsOnly.padLeft(14, '0');
    } else {
      return digitsOnly.substring(0, 14);
    }
  }

  static String getDefaultVehicleTypeId() {
    return '6469945aa4c3eb5241c0dae2';
  }
}
