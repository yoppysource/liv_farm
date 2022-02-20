// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:liv_farm/app/app.locator.dart';
// import 'package:liv_farm/ui/home/farm/offline_farm/offline_farm_viewmodel.dart';
// import 'package:liv_farm/ui/shared/offline_store_appbar/offline_store_appbar.dart';
// import 'package:liv_farm/ui/shared/styles.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:stacked/stacked.dart';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:stacked_services/stacked_services.dart';

// class OfflineFarmView extends StatefulWidget {
//   const OfflineFarmView({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _OfflineFarmViewState();
// }

// class _OfflineFarmViewState extends State<OfflineFarmView>
//     with WidgetsBindingObserver, SingleTickerProviderStateMixin {
//   final Permission _permission = Permission.camera;
//   bool _checkingPermission = false;
//   Barcode result;
//   QRViewController controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   final DialogService _dialogService = locator<DialogService>();
//   AnimationController _animationController;
//   Animation _animation;
//   Animation<Color> _colorTweenAnimation;
//   Tween<Color> _colorTween;

//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller.pauseCamera();
//     }
//     controller.resumeCamera();
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _animationController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     _animation =
//         CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
//     _colorTween = ColorTween(begin: Colors.white, end: Colors.black);
//     _colorTweenAnimation = _colorTween.animate(_animationController);
//     _checkPermission(_permission);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     controller.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.resumed && !_checkingPermission) {
//       _checkingPermission = true;
//       _checkPermission(_permission).then((_) => _checkingPermission = false);
//     }
//   }

//   Future<void> _checkPermission(Permission permission) async {
//     final status = await permission.request();
//     if (status == PermissionStatus.denied ||
//         status == PermissionStatus.permanentlyDenied) {
//       DialogResponse _response = await _dialogService.showDialog(
//           title: "카메라 권한",
//           description: '매장 내 상품 스캔을 하시려면 카메라 기능을 허용해주세요',
//           cancelTitle: '사용 안함',
//           buttonTitle: '설정으로 가기');
//       if (_response.confirmed) return openAppSettings();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<OfflineFarmViewModel>.reactive(
//       viewModelBuilder: () => OfflineFarmViewModel(),
//       builder: (context, model, child) => Scaffold(
//         backgroundColor: Colors.black,
//         appBar: PreferredSize(
//           child: OfflineStoreAppbarView(),
//           preferredSize: Size.fromHeight(50),
//         ),
//         body: Column(
//           children: <Widget>[
//             Expanded(
//                 flex: 4,
//                 child: Stack(
//                   children: [
//                     _buildQrView(context, model),
//                     AnimatedBuilder(
//                       animation: _animationController,
//                       child: Container(
//                         color: Colors.black87,
//                         child: Center(
//                           child: Text(
//                             '하단의 녹색 화살표를 누르고\nQR 코드를 스캔해주세요',
//                             textAlign: TextAlign.center,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyText1
//                                 .copyWith(color: Colors.white70),
//                           ),
//                         ),
//                       ),
//                       builder: (context, child) =>
//                           Opacity(opacity: 1 - _animation.value, child: child),
//                     ),
//                     Align(
//                       alignment: Alignment.topCenter,
//                       child: AnimatedBuilder(
//                         animation: _animationController,
//                         child: Container(
//                           height: 30,
//                           color: Colors.white,
//                           child: Center(
//                             child: Text(
//                               "QR코드 스캔 중",
//                               style: TextStyle(
//                                 color: kSubColor.withOpacity(0.9),
//                               ),
//                             ),
//                           ),
//                         ),
//                         builder: (context, child) =>
//                             Opacity(opacity: _animation.value, child: child),
//                       ),
//                     ),
//                   ],
//                 )),
//             Expanded(
//               flex: 1,
//               child: Listener(
//                 onPointerDown: (event) {
//                   print('point Down');
//                   model.isScanning = true;
//                   _animationController.forward();

//                   // _model.onPointerDown();
//                 },
//                 onPointerUp: (event) {
//                   print('point up');
//                   model.isScanning = false;
//                   _animationController.reverse();
//                   // _model.setInitialState();
//                 },
//                 child: AnimatedBuilder(
//                   animation: _animationController,
//                   builder: (context, _) => Container(
//                     color: _colorTweenAnimation.value,
//                     width: double.infinity,
//                     child: Center(
//                       child: SizedBox(
//                           height: 60 + 15 * (_animation.value),
//                           width: 60 + 15 * (_animation.value),
//                           child: Image.asset('assets/images/arrow_down.png')),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQrView(BuildContext context, OfflineFarmViewModel model) {
//     // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 150.0
//         : 300.0;
//     // To ensure the Scanner view is properly sizes after rotation
//     // we need to listen for Flutter SizeChanged notification and update controller
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: (controller) => _onQRViewCreated(controller, model),
//       overlay: QrScannerOverlayShape(
//           borderColor: kMainPink,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: scanArea),
//     );
//   }

//   void _onQRViewCreated(
//       QRViewController controller, OfflineFarmViewModel model) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       if (!model.isScanning) return;
//       Barcode _barcode = scanData;
//       model.getProductDetailPageFromQRCode(_barcode.code, _animationController);
//     });
//   }
// }
