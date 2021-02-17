import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/product_description_page/addtional_information_page.dart';
import 'package:liv_farm/ui/product_description_page/product_bottom_page_view.dart';
import 'package:liv_farm/ui/product_description_page/review_page.dart';
import 'package:liv_farm/ui/product_description_page/tabs_view.dart';

class BottomTabBar extends StatefulWidget {
  final List<Tab> tabs;
  final Product product;

  const BottomTabBar({Key key, this.tabs, this.product}) : super(key: key);


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
            // TabBar(
            //   onTap: (index) {
            //     setState(() {
            //       _tabIndex = index;
            //     });
            //   },
            //   labelStyle: Theme.of(context).textTheme.bodyText1,
            //   indicator: UnderlineTabIndicator(
            //       borderSide:
            //       BorderSide(width: 3, color: Color(kMainColor)),
            //       insets: EdgeInsets.symmetric(horizontal:60, vertical: 8)),
            //   tabs: widget.tabs,),
            // SizedBox(height: 10,),
            // ProductBottomPageView(children: [AdditionalInformationPage(product: widget.product,), ReviewPage()],)
            // TabsView(tabIndex: _tabIndex,
            //   firstTab: ,
            //   secondTab: ,
            // ),
          ],
        )
    );
  }
}
