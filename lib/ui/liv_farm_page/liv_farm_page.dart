import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';

class LivFarmPage extends StatefulWidget {
  @override
  _LivFarmPageState createState() => _LivFarmPageState();
}

class _LivFarmPageState extends State<LivFarmPage> {
  ScrollController _controller;
  bool isScrollOnStart = true;
  bool isScrollOnEnd = false;

  @override
  void initState() {
    _controller = ScrollController()
      ..addListener(() {
        // 현재 스크롤 정보를 기반으로 해서 분기를 하고, setState를 걸어주기
        if (_controller.offset >= _controller.position.maxScrollExtent) {
          setState(() {
            isScrollOnEnd = true;
          });
        }else{
          setState(() {
            isScrollOnEnd = false;
          });
        }
        if (_controller.offset >= _controller.position.minScrollExtent+300) {
          setState(() {
            isScrollOnStart = false;
          });
        } else{
          setState(() {
            isScrollOnStart = true;
          });
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _controller,
            child: Center(child: Image.asset('assets/images/brand.jpg')),
          ),
          isScrollOnStart == false
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: IconButton(
                        icon: Icon(
                          CupertinoIcons.chevron_compact_up,
                          size: 50,
                          color: Color(kMainColor),
                        ),
                        onPressed: () async {
                          double scrollDistance = _controller.offset -(deviceHeight - 60);
// controller
                          await _controller.animateTo(scrollDistance,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        }),
                  ),
                )
              : Container(),
          isScrollOnEnd == false
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: IconButton(
                        icon: Icon(
                          CupertinoIcons.chevron_compact_down,
                          size: 50,
                          color: Color(kMainColor),
                        ),
                        onPressed: () async {
                          double scrollDistance =
                              _controller.offset + deviceHeight - 60;
// controller
                          await _controller.animateTo(scrollDistance,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        }),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
