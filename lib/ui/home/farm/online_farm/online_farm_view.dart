import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/ui/home/farm/online_farm/online_farm_viewmodel.dart';
import 'package:liv_farm/ui/home/farm/online_farm/product_grid_view.dart';
import 'package:liv_farm/ui/home/farm/online_farm/product_serch_delegate.dart';
import 'package:liv_farm/ui/shared/address_appbar/address_appbar_view.dart';
import 'package:liv_farm/ui/shared/my_tap_item.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:liv_farm/util/category_enum.dart';
import 'package:stacked/stacked.dart';

class OnlineFarmView extends StatefulWidget {
  const OnlineFarmView({Key? key}) : super(key: key);

  @override
  _OnlineFarmViewState createState() => _OnlineFarmViewState();
}

class _OnlineFarmViewState extends State<OnlineFarmView>
    with TickerProviderStateMixin {
  late ScrollController _scrollViewController;
  late TabController _tabController;

  @override
  void initState() {
    _scrollViewController = ScrollController();
    _tabController = TabController(
        length: locator<OnlineFarmViewModel>().tabBarLength, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnlineFarmViewModel>.reactive(
      viewModelBuilder: () => locator<OnlineFarmViewModel>(),
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) => DefaultTabController(
        length: model.tabBarLength,
        child: SafeArea(
          child: Scaffold(
            appBar: const PreferredSize(
              child: AddressAppBarView(),
              preferredSize: Size.fromHeight(50),
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
                      background: SizedBox(
                        height: 100,
                        child: Column(
                          children: <Widget>[
                            verticalSpaceRegular,
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () async {
                                  String? productName = await showSearch(
                                      context: context,
                                      delegate: ProductSearchDelegate(model
                                          .productCategoryToInventoryList.values
                                          .expand((i) => i)
                                          .toList()));

                                  if (productName != null) {
                                    Inventory searchedProduct = model
                                        .productCategoryToInventoryList.values
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
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text('상품명으로 검색하기',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                          ),
                                          const Align(
                                            alignment: Alignment.centerRight,
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
                            verticalSpaceRegular,
                            // Container(
                            //   color: kMainGrey,
                            //   width: MediaQuery.of(context).size.width,
                            //   height: MediaQuery.of(context).size.width * 0.6,
                            //   child: const EventBannerView(),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    expandedHeight: 36 + 40 + 50,
                    // MediaQuery.of(context).size.width * 0.6 +
                    collapsedHeight: 10,
                    toolbarHeight: 0,
                    pinned: true,
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        labelPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15), //
                        indicator: BubbleTabIndicator(
                          indicatorHeight: 50.0,
                          indicatorColor: kMainColor.withOpacity(0.55),
                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
                          // Other flags
                          indicatorRadius: 20,
                          insets: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                        ),
                        indicatorWeight: 0,
                        tabs: model.productCategoryList
                            .map((ProductCategory category) =>
                                MyTabItem(label: category.string))
                            .toList()),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: model.productCategoryList
                    .map(
                      (ProductCategory category) => ProductGridView(
                        inventoryList:
                            model.productCategoryToInventoryList[category]!,
                        model: model,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
