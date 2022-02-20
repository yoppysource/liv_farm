import 'package:dartz/dartz.dart';
import 'package:liv_farm/services/cart_validation_service/cart_request_validation_exception.dart';
import 'package:liv_farm/services/cart_validation_service/model/cart_request.dart';
import 'package:liv_farm/util/validation_rule.dart';

abstract class CartRequestValidationRule
    implements ValidationRule<CartRequestValidationException, CartRequest> {}

class StoreAvailableRule extends CartRequestValidationRule {
  final bool availalbeForDelivery;
  final bool availalbeForTakeOut;

  StoreAvailableRule(
      {required this.availalbeForDelivery, required this.availalbeForTakeOut});

  @override
  Either<CartRequestValidationException, CartRequest> validate(
      CartRequest request) {
    if (request.isDelivery) {
      return availalbeForDelivery
          ? right(request)
          : left(CartRequestValidationException(
              cartRequest: request, message: "배송이 불가능한 매장입니다"));
    } else {
      return availalbeForDelivery
          ? right(request)
          : left(CartRequestValidationException(
              cartRequest: request, message: "포장주문이 불가능한 매장입니다"));
    }
  }
}

class DistanceRule extends CartRequestValidationRule {
  final int maxDistance;
  final double? distanceFromStore;

  DistanceRule({required this.maxDistance, this.distanceFromStore});

  @override
  Either<CartRequestValidationException, CartRequest> validate(
      CartRequest request) {
    if (request.isDelivery) {
      if (distanceFromStore == null) {
        return left(CartRequestValidationException(
            cartRequest: request, message: "주소를 입력해주세요"));
      }
      return maxDistance >= distanceFromStore!
          ? right(request)
          : left(CartRequestValidationException(
              cartRequest: request, message: "배송이 불가능한 주소입니다"));
    } else {
      return right(request);
    }
  }
}

class InformationRule extends CartRequestValidationRule {
  InformationRule();

  @override
  Either<CartRequestValidationException, CartRequest> validate(
      CartRequest request) {
    String invalidInformation = '';
    if (!isValidString(request.name)) invalidInformation += "성함";
    if (!isValidString(request.phoneNumber)) {
      invalidInformation += '${invalidInformation.isNotEmpty ? ", " : ""}연락처';
    }
    if (request.isDelivery && !isValidString(request.address)) {
      invalidInformation += '${invalidInformation.isNotEmpty ? ", " : ""}주소';
    }
    return (invalidInformation.isEmpty)
        ? right(request)
        : left(CartRequestValidationException(
            cartRequest: request, message: invalidInformation + "를(을) 입력해주세요"));
  }

  bool isValidString(String? str) {
    if (str == null || str.trim() == '') {
      return false;
    } else {
      return true;
    }
  }
}

class MinimumAmoutRule extends CartRequestValidationRule {
  final int minimumAmountDelivery;
  final int minimumAmountTakeOut;

  MinimumAmoutRule(
      {required this.minimumAmountDelivery,
      required this.minimumAmountTakeOut});

  @override
  Either<CartRequestValidationException, CartRequest> validate(
      CartRequest request) {
    if (request.isDelivery) {
      return minimumAmountDelivery <= request.amount
          ? right(request)
          : left(CartRequestValidationException(
              cartRequest: request,
              message: "최소 주문 금액은 $minimumAmountDelivery원입니다"));
    } else {
      return minimumAmountTakeOut <= request.amount
          ? right(request)
          : left(CartRequestValidationException(
              cartRequest: request,
              message: "최소 주문 금액은 $minimumAmountTakeOut원입니다"));
    }
  }
}
