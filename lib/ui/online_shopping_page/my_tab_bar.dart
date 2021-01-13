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
        unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
            letterSpacing: 1,
            fontSize: 14),
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          letterSpacing: 1,
        ),
        indicator: UnderlineTabIndicator(
            borderSide:
            BorderSide(width: 3, color: Color(kMainColor)),
            insets: EdgeInsets.symmetric(horizontal:26, vertical: 10)),
        controller: _tabController,
        tabs: [
          Tab(
            child: Text(
              '키트',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Tab(
            child: Text(
              '곁들임',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Tab(
            child: Text(
              '상추',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Tab(
            child: Text(
              '채소',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Tab(
            child: Text(
              '허브',
             style: TextStyle(color: Colors.black),
            ),
          ),
        ]);
  }
}
