import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';

class LivFarmPage extends StatefulWidget {
  @override
  _LivFarmPageState createState() => _LivFarmPageState();
}

class _LivFarmPageState extends State<LivFarmPage> {

  ScrollController _controller = ScrollController();
  bool isScrollEnd = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _controller,
            child: Image.asset('assets/images/brand.jpg'),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: isScrollEnd==false ?
                IconButton(icon: Icon(CupertinoIcons.chevron_compact_down, size: 50, color: Color(kMainColor),), onPressed: () async {
                  double scrollDistance =  _controller.offset + deviceHeight -60;

                  await _controller.animateTo(scrollDistance, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                  if(_controller.offset >1500) {
                    setState(() {
                      isScrollEnd = true;
                    });
                  }
                }) : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
