import 'package:flutter_test/flutter_test.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:uchiha_saving/screens/auth_screen/auth_screeen.dart';

main(){

  test(" validator test here,empty password returns email",(){
    bool isValid = EmailValidator(errorText: "Not Valid").isValid("email@gmail.com");

    expect(isValid, true);
  });

  test(" validator test here,empty password returns email",(){
      bool isValid = EmailValidator(errorText: "Not Valid").isValid("email@gmailcom");

      expect(isValid, false);
  });
  test(" validator test here,empty password returns email",(){
    bool isValid = EmailValidator(errorText: "Not Valid").isValid("emailgmail.com");

    expect(isValid, false);
  });

  test(" validator test here,empty password returns email",(){
    bool isValid = EmailValidator(errorText: "Not Valid").isValid("gmail.com");

    expect(isValid, false);
  });
}