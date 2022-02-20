import 'package:liv_farm/model/store.dart';
import 'package:liv_farm/services/cart_validation_service/cart_request_validation_exception.dart';
import 'package:liv_farm/services/cart_validation_service/model/cart_request.dart';
import 'package:liv_farm/services/cart_validation_service/model/rules/cart_request_validation_rule.dart';
import 'package:liv_farm/util/validation_rule.dart';
import 'package:liv_farm/util/validation_service.dart';

class CartValidationService
    with ValidationService<CartRequestValidationException, CartRequest> {
  @override
  final List<ValidationRule<CartRequestValidationException, CartRequest>> rules;

  CartValidationService({
    required this.rules,
  });

  factory CartValidationService.withStore(Store currentStore) =>
      CartValidationService(rules: [
        StoreAvailableRule(
            availalbeForDelivery: currentStore.takeOut,
            availalbeForTakeOut: currentStore.delivery),
        DistanceRule(
            maxDistance: currentStore.maxDistance,
            distanceFromStore: currentStore.distance),
        InformationRule(),
        MinimumAmoutRule(
            minimumAmountTakeOut: 1000,
            minimumAmountDelivery: currentStore.minAmountForDelivery),
      ]);
}
