import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog(
      {@required String title, @required content,})
      : super(
          title: title,
          widget: Text(content, style: TextStyle(fontSize: 16.0, fontFamily: 'Spoqa Han Sans', color: Colors.black.withOpacity(0.8))),
          defaultActionText: 'OK',
        );
}

