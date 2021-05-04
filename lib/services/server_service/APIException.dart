class APIException implements Exception {
  final int statusCode;
  final String message;
  final String status;

  APIException(this.statusCode, this.message, this.status);
}
