import 'package:form_field_validator/form_field_validator.dart';

final nameValidator =
    MultiValidator([RequiredValidator(errorText: 'Username is required')]);

final passwordRequireValidator =
    MultiValidator([RequiredValidator(errorText: 'Password is required')]);

final messageRequireValidator =
    MultiValidator([RequiredValidator(errorText: 'Nothing to send')]);

final prnValidator =
    MultiValidator([RequiredValidator(errorText: 'PRN is required')]);

final bioValidator =
    MultiValidator([RequiredValidator(errorText: 'Name is required')]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: 'Enter a valid email address')
]);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
  // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
  //     errorText: 'passwords must have at least one special character')
]);

MultiValidator myValidator({required String requiredField}) {
  return MultiValidator(
      [RequiredValidator(errorText: '$requiredField is required')]);
}

MultiValidator myEmailValidator(
    {required String requiredField, required String email}) {
  return MultiValidator(
    [
      RequiredValidator(errorText: '$requiredField is required'),
      EmailValidator(errorText: 'Enter a valid email address'),
    ],
  );
}
