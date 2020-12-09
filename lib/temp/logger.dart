import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Log extends Logger  {
  void builderLog({@required className}) => d('$className Builder Called');

  void methodLog({@required method}) => i('$method called');
}

var log = Log();