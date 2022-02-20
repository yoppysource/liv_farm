import 'package:liv_farm/services/cart_validation_service/model/cart_request.dart';

class CartRequestValidationException implements Exception {
  final CartRequest cartRequest;
  final String message;

  const CartRequestValidationException({
    required this.cartRequest,
    required this.message,
  });
}
