import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/home/farm/online_farm/online_farm_viewmodel.dart';
import 'package:liv_farm/ui/home/farm/online_farm/product_grid_view.dart';
import 'package:liv_farm/ui/home/farm/online_farm/product_serch_delegate.dart';
import 'package:liv_farm/ui/shared/address_appbar/address_appbar_view.dart';
import 'package:liv_farm/ui/shared/my_tap_item.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';
import 'event_banner/event_banner_viewmodel.dart';

class OnlineFarmView extends StatefulWidget {
  const OnlineFarmView({Key key}) : super(key: key);

  @override
  _OnlineFarmViewState createState() => _OnlineFarmViewState();
}

class _OnlineFarmViewState extends State<OnlineFarmView> with TickerProviderStateMixin {
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
    return ViewModelBuilder<OnlineFarmViewModel>.reactive(
      viewModelBuilder: () => OnlineFarmViewModel(),
      builder: (context, model, child) => DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(child:  AddressAppBarView(), preferredSize: new Size.fromHeight(50),
            ),
            body: NestedScrollView(
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
                                verticalSpaceRegular,
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () async {
                                      String productName = await showSearch(
                                          context: context,
                                          delegate: ProductSearchDelegate(
                                              model.inventoryMapByCategory
                                                  .values
                                                  .expand((i) => i)
                                                  .toList()));

                                      if (productName != null) {
                                        Inventory searchedProduct = model
                                            .inventoryMapByCategory.values
                                            .expand((i) => i)
                                            .toList()
                                            .firstWhere((element) =>
                                                element.product.name ==
                                                productName);
                                        model
                                            .navigateToProductDetailViewBySearchingProduct(
                                                searchedProduct);
                                      }
                                    },
                                    child: Padding(
                                      padding: horizontalPaddingToScaffold,
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: kMainGrey, width: 0.25),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text('상품명으로 검색하기',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(
                                                  CupertinoIcons.search,
                                                  size: 25,
                                                  color: kMainGrey,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                verticalSpaceMedium,
                                Container(
                                  color: kMainGrey,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: EventBannerView(),
                                ),
                              ],
                            ),
                          ),
                          expandedHeight:
                              MediaQuery.of(context).size.width * 0.6 + 160,
                          collapsedHeight: 10,
                          toolbarHeight: 0,
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
                                insets: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
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
                          inventoryList: model.inventoryMapByCategory[
                              ProductCategory.Vegetable],
                          model: model,
                        ),
                        ProductGridView(
                          inventoryList: model
                              .inventoryMapByCategory[ProductCategory.Salad],
                          model: model,
                        ),
                        ProductGridView(
                          inventoryList: model
                              .inventoryMapByCategory[ProductCategory.Grouped],
                          model: model,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
