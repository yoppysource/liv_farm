import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/ui/product_description_page/addtional_information_page.dart';
import 'package:liv_farm/ui/product_description_page/review_page.dart';
import 'package:liv_farm/ui/product_description_page/tabs_view.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';
import 'package:provider/provider.dart';

class BottomTabBar extends StatefulWidget {
  final List<Tab> tabs;

  const BottomTabBar({Key key, this.tabs}) : super(key: key);

  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {

  int _tabIndex = 0;


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: widget.tabs.length,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              onTap: (index) {
                setState(() {
                  _tabIndex = index;
                });
              },
              unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  letterSpacing: 1,
                  fontSize: 13),
              labelStyle: TextStyle(
                color: Colors.black54,
                letterSpacing: 1,
              ),
              indicator: UnderlineTabIndicator(
                  borderSide:
                  BorderSide(width: 3.0, color: Color(kMainColor)),
                  insets:
                  EdgeInsets.symmetric(horizontal: 75, vertical: 10)),
              tabs: widget.tabs,),
            SizedBox(height: 10,),
            TabsView(tabIndex: _tabIndex,
              firstTab: AdditionalInformationPage(),
              secondTab: ReviewPage(),
            ),
          ],
        )
    );
  }
}
