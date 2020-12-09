// import 'package:flutter/material.dart';
// import 'package:liv_farm/viewmodel/purchase_log_view_model.dart';
// import 'package:provider/provider.dart';
//
// class PurchaseLogPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     MyFarmPageViewModel _model =
//         Provider.of<MyFarmPageViewModel>(context, listen: true);
//     if (_model.isLoading == true) {
//       return Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     } else if (_model.isLoading == false && _model.purchaseList == null) {
//       return Scaffold(
//         body: Center(
//           child: Text('error'),
//         ),
//       );
//     } else if (_model.purchaseList.isEmpty) {
//       return Scaffold(
//         body: Center(
//           child: Text('빈 값'),
//         ),
//       );
//     } else {
//       Scaffold(
//         body: Center(
//           child: Text('${_model.currentPurchaseLog.toString()}'),
//         ),
//       );
//     }
//   }
// }
