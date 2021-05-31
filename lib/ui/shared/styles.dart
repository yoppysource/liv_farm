import 'package:flutter/material.dart';

const EdgeInsets horizontalPaddingToScaffold =
    EdgeInsets.symmetric(horizontal: 10);

const double bottomBottomHeight = 65;
const BorderRadius bottomButtonBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(10),
  topRight: Radius.circular(10),
);

const BorderRadius kSmallBorderRadius = BorderRadius.all(Radius.circular(5));
const BorderRadius kLargeBorderRadius = BorderRadius.all(Radius.circular(10));

const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
const Widget horizontalSpaceRegular = SizedBox(width: 18.0);
const Widget horizontalSpaceMedium = SizedBox(width: 25.0);
const Widget horizontalSpaceLarge = SizedBox(width: 50.0);

const Widget verticalSpaceTiny = SizedBox(height: 5.0);
const Widget verticalSpaceSmall = SizedBox(height: 10.0);
const Widget verticalSpaceRegular = SizedBox(height: 18.0);
const Widget verticalSpaceMedium = SizedBox(height: 25);
const Widget verticalSpaceLarge = SizedBox(height: 50.0);
const Widget verticalSpaceMassive = SizedBox(height: 120.0);

//Color
const Color kMainColor = Color(0xff91D833);
const Color kSubColor = Color(0xffC5299B);

const Color kMainBlack = Color(0xff333333);
const Color kMainGrey = Color(0xff828282);
// const Color kMainLightPink = Color(0xffF8d9e0);
const Color kMainLightPink = Color(0xffC5299B);

const Color kMainGreen = Color(0xff93ca23);
const Color kMainDarkGreen = Color(0xff868a53);
const Color kMainIvory = Color(0xfffaf9f7);
// const Color kMainPink = Color(0xfff59890);
const Color kMainPink = Color(0xffC5299B);

// const Color kBrightPink = Color(0xffF8d9e0);
const Color kBrightPink = Color(0xffC5299B);
//Size
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;
double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;

//Icon
final Icon kArrowBack = Icon(
  Icons.arrow_back_rounded,
  color: Colors.black.withOpacity(0.75),
  size: 32,
);

//asset const

const String kLogo = 'assets/images/livLogo.png';
const String IMG_brand = 'assets/images/brand.jpg';
