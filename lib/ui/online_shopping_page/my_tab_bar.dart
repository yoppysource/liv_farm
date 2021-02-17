import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({
    Key key,
    @required TabController tabController,
  }) : _tabController = tabController, super(key: key);

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
        labelStyle: Theme.of(context).textTheme.bodyText1,
        indicator: UnderlineTabIndicator(
            borderSide:
            BorderSide(width: 3, color: Color(kMainColor)),
            insets: EdgeInsets.symmetric(horizontal:45, vertical: 8)),
        controller: _tabController,
        tabs: [
          Tab(
            child: Text(
              '채소',
            ),
          ),
          Tab(
            child: Text(
              '샐러드',
            ),
          ),
          Tab(
            child: Text(
              '모둠 샘플러',
            ),
          ),
        ]);
  }
}
