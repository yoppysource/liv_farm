import 'package:flutter/foundation.dart';

class Address {
  final String address;
  final String postCode;

  Address({@required this.address, @required this.postCode});

  static List<String> validAddress = [
  '위례',
  '복정',
  '태평',
  '양지',
  '단대',
  '하대원',
  '상대원',
  '중앙',
  '성남',
  '수진',
  '야탑',
  '이매',
  '삼평동',
  '도촌동',
  '은행',
  '금광',
  '산성',
  '신흥',
  '양지'];
}