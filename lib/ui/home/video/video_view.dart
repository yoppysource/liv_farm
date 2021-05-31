import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoView extends StatefulWidget {
  static String streamingTag;
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController _videoPlayerController;
  PageController _pageController;

  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset(
        'assets/videos/video.mp4',
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    // _pageController = PageController();
    if (mounted) {
      _videoPlayerController.initialize().then((_) {
        _videoPlayerController.setVolume(0);
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _videoPlayerController.value.initialized
            ?
            // PageView(
            //     scrollDirection: Axis.vertical,
            //     controller: _pageController,
            //     children: [
            SizedBox.expand(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoPlayerController.value.size?.width ?? 0,
                          height:
                              _videoPlayerController.value.size?.height ?? 0,
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () async {
                          if (VideoView.streamingTag == null) {
                            locator<DialogService>().showDialog(
                              title: '안내',
                              description: "일시적인 오류가 발생했습니다. \n다음에 다시 시도해주세요",
                              buttonTitle: "확인",
                            );
                          } else {
                            await canLaunch(
                                    "https://www.youtube.com/watch?v=${VideoView.streamingTag ?? ''}")
                                ? await launch(
                                    "https://www.youtube.com/watch?v=${VideoView.streamingTag}")
                                : locator<DialogService>().showDialog(
                                    title: '안내',
                                    description:
                                        "일시적인 오류가 발생했습니다. \n다음에 다시 시도해주세요",
                                    buttonTitle: "확인",
                                  );
                          }
                          _pageController.nextPage(
                              curve: Curves.easeIn,
                              duration: Duration(milliseconds: 500));
                        },
                        child: Container(
                          height: bottomBottomHeight,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: bottomButtonBorderRadius,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: horizontalPaddingToScaffold,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      '농장 실시간 구경하러 가기',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  horizontalSpaceTiny,
                                  Container(
                                      child: Icon(
                                    CupertinoIcons.arrow_right,
                                    size: 18,
                                    color: Color(0xff333333),
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            // YoutubePlayerBuilder(
            //     onExitFullScreen: () {
            //       SystemChrome.setPreferredOrientations(
            //           DeviceOrientation.values);
            //     },
            //     player: YoutubePlayer(
            //       controller: YoutubePlayerController(
            //         initialVideoId: '${VideoView.streamingTag}',
            //         flags: const YoutubePlayerFlags(
            //           hideControls: true,
            //           mute: true,
            //           autoPlay: true,
            //           disableDragSeek: false,
            //           loop: false,
            //           isLive: false,
            //           forceHD: false,
            //           enableCaption: false,
            //           hideThumbnail: true,
            //         ),
            //       ),
            //       showVideoProgressIndicator: false,
            //       bufferIndicator: Image.asset('images/app_icon.png'),
            //       controlsTimeOut: Duration(seconds: 0),
            //       progressIndicatorColor: Colors.blueAccent,
            //     ),
            //     builder: (context, player) {
            //       return SafeArea(
            //         child: Scaffold(
            //           backgroundColor: Colors.white,
            //           body: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               verticalSpaceMedium,
            //               Row(
            //                 children: [
            //                   SizedBox(
            //                       width:
            //                           MediaQuery.of(context).size.width *
            //                               0.5,
            //                       child: Image.asset(
            //                           'assets/images/live.jpeg')),

            //                 ],
            //               ),
            //               SizedBox(
            //                 height:
            //                     MediaQuery.of(context).size.height * 0.12,
            //               ),
            //               Center(child: player),
            //             ],
            //           ),
            //         ),
            //       );
            //     }),
            //   ],
            // )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }
}
