class APIException implements Exception {
  final int statusCode;
  final String message;

  APIException(this.statusCode, this.message);
}
