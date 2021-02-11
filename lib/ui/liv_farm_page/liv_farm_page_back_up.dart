//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:liv_farm/repository/customer_log_repository.dart';
// import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
// import 'package:provider/provider.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// class LivFarmPage extends StatefulWidget {
//   static final YoutubePlayerController controller = YoutubePlayerController(
//     initialVideoId: '1GNFMqiNPaA',
//     flags: const YoutubePlayerFlags(
//       hideControls: true,
//       mute: true,
//       autoPlay: true,
//       disableDragSeek: false,
//       loop: false,
//       isLive: false,
//       forceHD: false,
//       enableCaption: false,
//       hideThumbnail: true,
//     ),
//   );
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<LivFarmPage> {
//
// @override
//   void initState() {
//   CustomerLogRepository(Provider.of<LandingPageViewModel>(context,listen: false).user.id).sendLogDataToServer();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     // _controller.play();
//
//     return YoutubePlayerBuilder(
//       onExitFullScreen: () {
//         SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//       },
//       player: YoutubePlayer(
//         controller: LivFarmPage.controller,
//         showVideoProgressIndicator: false,
//         bufferIndicator: Image.asset('images/livLogo.png'),
//         controlsTimeOut: Duration(seconds: 0),
//         progressIndicatorColor: Colors.blueAccent,
//       ),
//       builder: (context, player) {
//
//         print('play!!');
//         return Scaffold(
//           body: player,
//         );}
//
//     );
//   }}