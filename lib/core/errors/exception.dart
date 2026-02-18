class CustomException implements Exception {
  final String exMessage;
  CustomException(this.exMessage);
  @override
  toString() => exMessage;
}
