// import 'package:flutter/material.dart';
//
// class TabsView extends StatelessWidget {
//   TabsView(
//       {Key key,
//         @required this.tabIndex,
//         @required this.firstTab,
//         @required this.secondTab})
//       : super(key: key);
//   final int tabIndex;
//   final Widget firstTab;
//   final Widget secondTab;
//   @override
//   Widget build(BuildContext context) {
//     // pageView =>
//     // Stack -> Listview -> pageview -> review 정적 height로 주기.
//
//     return Stack(
//       //pageView
//       children: <Widget>[
//         AnimatedContainer(
//           child: firstTab,
//           width: MediaQuery.of(context).size.width,
//           transform: Matrix4.translationValues(
//               tabIndex == 0 ? 0 : -MediaQuery.of(context).size.width, 0, 0),
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeIn,
//         ),
//         //position: fixed
//         AnimatedContainer(
//           child: secondTab,
//           width:MediaQuery.of(context).size.width,
//           transform: Matrix4.translationValues(
//               tabIndex == 1 ? 0 : MediaQuery.of(context).size.width, 0, 0),
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeIn,
//         )
//       ],
//     );
//   }
// }