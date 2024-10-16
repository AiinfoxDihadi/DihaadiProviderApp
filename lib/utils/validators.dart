import 'package:form_field_validator/form_field_validator.dart';

class Validator {

  static var passwordValidate = MultiValidator([
    RequiredValidator(errorText: "Please enter password."),
    PatternValidator(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])', errorText: "Password must be 8-12 characters long, and contain at least 1 uppercase, 1 lowercase, 1 number and 1 special character."),
  ]);

  static var passwordOldValidate = MultiValidator([
    RequiredValidator(errorText: "Please enter old password."),
    PatternValidator(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])', errorText: "Password must be 8-12 characters long, and contain at least 1 uppercase, 1 lowercase, 1 number and 1 special character."),
  ]);

  static var passwordNewValidate = MultiValidator([
    RequiredValidator(errorText: "Please enter New password."),
    PatternValidator(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])', errorText: "Password must be 8-12 characters long, and contain at least 1 uppercase, 1 lowercase, 1 number and 1 special character."),
  ]);

  static var passwordConfirmValidate = MultiValidator([
    RequiredValidator(errorText: "Please enter confirm password."),
    PatternValidator(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])', errorText: "Password must be 8-12 characters long, and contain at least 1 uppercase, 1 lowercase, 1 number and 1 special character."),
  ]);

  static var phoneNumberValidate = MultiValidator([
    RequiredValidator(errorText: 'Please enter phone number'),
    PatternValidator(r'(^(?:[+0]9)?[0-9]{10}$)',errorText: "Phone number must be 10 digits")
  ]);

  static var otpValidate = MultiValidator([
    RequiredValidator(errorText: 'Please enter OTP'),
    PatternValidator(r'^\d{4}$', errorText: "Phone number must be 4 digits")
  ]);
}