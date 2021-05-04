import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/home/farm/farm_viewmodel.dart';
import 'package:liv_farm/ui/home/farm/product_grid_view.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

class FarmView extends StatefulWidget {
  const FarmView({Key key}) : super(key: key);

  @override
  _FarmViewState createState() => _FarmViewState();
}

class _FarmViewState extends State<FarmView> with TickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  @override
  void initState() {
    _scrollViewController = ScrollController();
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _scrollViewController?.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FarmViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) => DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Padding(
            padding: horizontalPaddingToScaffold,
            child: Scaffold(
              body: model.data == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : NestedScrollView(
                      controller: _scrollViewController,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            backgroundColor: kMainIvory,
                            elevation: 0, // app bar color
                            flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.pin,
                              centerTitle: true,
                              titlePadding: EdgeInsets.zero,
                              background: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        alignment: Alignment.centerRight,
                                        icon: Icon(
                                          CupertinoIcons.search,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {}),
                                  ),
                                  verticalSpaceRegular,
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      color: kMainGrey,
                                      height: 200,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            expandedHeight: 330,
                            collapsedHeight: 60,
                            pinned: true,
                            floating: true,
                            forceElevated: innerBoxIsScrolled,
                            bottom: TabBar(
                              controller: _tabController,
                              indicator: BubbleTabIndicator(
                                  indicatorHeight: 50.0,
                                  indicatorColor: kMainColor.withOpacity(0.55),
                                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                                  // Other flags
                                  indicatorRadius: 30,
                                  insets: EdgeInsets.all(5),
                                  padding: EdgeInsets.zero),
                              indicatorWeight: 0,
                              labelPadding: EdgeInsets.symmetric(vertical: 15),
                              tabs: [
                                MyTabItem(label: '수확채소'),
                                MyTabItem(label: '샐러드'),
                                MyTabItem(label: '모둠샘플러'),
                              ],
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          ProductGridView(
                            productList: model.data[ProductCategory.Vegetable],
                            model: model,
                          ),
                          ProductGridView(
                            productList: model.data[ProductCategory.Salad],
                            model: model,
                          ),
                          ProductGridView(
                            productList: model.data[ProductCategory.Grouped],
                            model: model,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => locator<FarmViewModel>(),
    );
  }
}

class MyTabItem extends StatelessWidget {
  final String label;

  const MyTabItem({Key key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Color(0xff333333),
              )),
    );
  }
}
