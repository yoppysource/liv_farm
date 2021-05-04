import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/add_to_cart_bottom_sheet/add_to_cart_bottom_sheet_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/customer_service_bottom_sheet/customer_service_bottom_sheet_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/gender_select_bottom_sheet/gender_select_bottom_sheet_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/pick_date_time_bottom_sheet/pick_date_time_bottom_sheet_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/review_bottom_sheet/review_bottom_sheet_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/write_bottom_sheet/write_bottom_sheet_view.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked_services/stacked_services.dart';

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.Basic: (context, sheetRequest, completer) =>
        _GeneralBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.AddToCart: (context, sheetRequest, completer) =>
        AddToCartBottomSheetView(request: sheetRequest, completer: completer),
    BottomSheetType.Write: (context, sheetRequest, completer) =>
        WriteBottomSheetView(request: sheetRequest, completer: completer),
    BottomSheetType.GetDateTime: (context, sheetRequest, completer) =>
        PickDateTimeBottomSheetView(
            request: sheetRequest, completer: completer),
    BottomSheetType.GetGender: (context, sheetRequest, completer) =>
        GenderSelectBottomSheetView(
            request: sheetRequest, completer: completer),
    BottomSheetType.CustomerService: (context, sheetRequest, completer) =>
        CustomerServiceBottomSheetView(
            request: sheetRequest, completer: completer),
    BottomSheetType.Review: (context, sheetRequest, completer) =>
        ReviewBottomSheetView(request: sheetRequest, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}

class _GeneralBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  final Color buttonTextColor = kMainPink;
  final Widget child;

  const _GeneralBottomSheet({Key key, this.request, this.completer, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (_) {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.title,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              verticalSpaceMedium,
              Text(
                request.description,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              verticalSpaceMedium,
              request.secondaryButtonTitle == null
                  ? FullScreenButton(
                      title: request.mainButtonTitle,
                      color: buttonTextColor,
                      onPressed: () =>
                          completer(SheetResponse(confirmed: true)),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            onPressed: () =>
                                completer(SheetResponse(confirmed: false)),
                            child: Text(
                              request.secondaryButtonTitle,
                              style: TextStyle(
                                  color: buttonTextColor, fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: FullScreenButton(
                            title: request.mainButtonTitle,
                            color: buttonTextColor,
                            onPressed: () =>
                                completer(SheetResponse(confirmed: true)),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenButton extends StatelessWidget {
  final double horizontalPadding;
  final Color color;
  final Color textColor;
  final bool busy;
  final String title;
  final bool outline;
  final Function onPressed;
  final bool enabled;
  final bool hasDropShadow;

  /// Height of the button. Default value is [screenHeightFraction(context, dividedBy: 18)]
  final double height;

  static BorderRadius _borderRadius = BorderRadius.circular(8);

  FullScreenButton({
    Key key,
    @required this.title,
    @required this.onPressed,
    this.horizontalPadding = 25,
    this.height,
    this.color,
    this.textColor = Colors.white,
    this.busy = false,
    this.outline = false,
    this.enabled = true,
    this.hasDropShadow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        height: height ?? screenHeightFraction(context, dividedBy: 15),
        width: screenWidthFraction(context, offsetBy: horizontalPadding * 2),
        decoration: outline
            ? BoxDecoration(
                border: Border.all(
                  color: enabled
                      ? (color ?? Theme.of(context).primaryColor)
                      : Colors.grey[350],
                  width: 1,
                ),
                borderRadius: _borderRadius,
              )
            : BoxDecoration(
                color: enabled
                    ? (color ?? Theme.of(context).primaryColor)
                    : Colors.grey[350],
                borderRadius: _borderRadius,
                boxShadow: [
                    if (hasDropShadow)
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                      )
                  ]),
        child: busy
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(!enabled
                    ? Colors.grey[350]
                    : outline
                        ? color
                        : textColor),
              )
            : Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: !enabled
                      ? Colors.grey[350]
                      : outline
                          ? (color ?? Theme.of(context).primaryColor)
                          : textColor,
                ),
              ),
      ),
    );
  }
}

double screenHeightFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
    min((screenHeight(context) - offsetBy) / dividedBy, max);

double screenWidthFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
    min((screenWidth(context) - offsetBy) / dividedBy, max);
