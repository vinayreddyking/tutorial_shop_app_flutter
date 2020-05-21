class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    if (message == null) return 'Exception';
    return 'Exception $message';
  }
}
