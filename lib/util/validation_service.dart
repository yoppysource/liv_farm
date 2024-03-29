import 'package:dartz/dartz.dart';
import 'package:liv_farm/util/validation_rule.dart';

mixin ValidationService<E extends Exception, T> {
  Iterable<ValidationRule<E, T>> get rules;
  Either<Iterable<E>, T> validate(T request) {
    final results = rules.map((rule) => rule.validate(request));

    if (results.every((result) => result.isRight())) {
      return right(request);
    }

    final it = results.where((result) => result.isLeft()).iterator;
    final exceptionList = <E>[];

    while (it.moveNext()) {
      it.current.fold((l) => exceptionList.add(l), (r) {});
    }

    return left(exceptionList);
  }
}
