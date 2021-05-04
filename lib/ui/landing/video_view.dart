import 'package:flutter/cupertino.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoView extends StatefulWidget {
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController _controller;

  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/video.mp4');
    if (mounted)
      _controller.initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _controller.value.initialized
            ? SizedBox.expand(
                child: Stack(
                  children: [
                    FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size?.width ?? 0,
                        height: _controller.value.size?.height ?? 0,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () async {
                          await canLaunch(
                                  "https://www.youtube.com/watch?v=KINQxhRSW1Q")
                              ? await launch(
                                  "https://www.youtube.com/watch?v=KINQxhRSW1Q")
                              : locator<DialogService>().showDialog(
                                  title: '안내',
                                  description:
                                      "일시적인 오류가 발생했습니다. \n다음에 다시 시도해주세요",
                                  buttonTitle: "확인",
                                );
                        },
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
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
                                          .subtitle2
                                          .copyWith(color: kMainGrey),
                                    ),
                                  ),
                                  horizontalSpaceTiny,
                                  Container(
                                      child: Icon(
                                    CupertinoIcons.arrow_right,
                                    color: kMainGrey,
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
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
