abstract class StringValidator {
  bool isValid(String value);
}


class NonEmptyStringValidator implements StringValidator{
  @override
  bool isValid(String value) {
    return value.isNotEmpty || value != null;
  }
}

class InputValidatorsForOrder{
  final StringValidator nameValidator = NonEmptyStringValidator();
  final StringValidator postCodeValidator = NonEmptyStringValidator();
  final StringValidator addressValidator = NonEmptyStringValidator();
  final StringValidator addressDetailValidator = NonEmptyStringValidator();
  final StringValidator phoneNumberValidator = NonEmptyStringValidator();

  final String invalidErrorText = '주문 시, 필수 입력 값입니다.';
}