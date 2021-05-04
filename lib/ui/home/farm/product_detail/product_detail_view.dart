import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/home/farm/farm_view.dart';
import 'package:liv_farm/ui/home/farm/product_detail/product_detail_viewmodel.dart';
import 'package:liv_farm/ui/home/farm/product_detail/reviews/reviews_view.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/my_icons_icons.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

class ProductDetailView extends StatefulWidget {
  final Product product;

  const ProductDetailView({Key key, @required this.product}) : super(key: key);

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView>
    with Formatter, SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;
  @override
  void initState() {
    _scrollViewController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductDetailViewModel>.reactive(
      viewModelBuilder: () => ProductDetailViewModel(product: widget.product),
      builder: (context, model, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          body: model.product == null || model.isBusy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    SafeArea(
                      child: NestedScrollView(
                        controller: _scrollViewController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverPadding(
                                padding: EdgeInsets.all(0),
                                sliver: SliverList(
                                    delegate: SliverChildListDelegate([
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Stack(
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  model.product.thumbnailPath,
                                              fit: BoxFit.fitWidth,
                                              placeholder: (context, url) =>
                                                  Image(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        model.product
                                                            .thumbnailPath),
                                                fit: BoxFit.fitWidth,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                horizontalPaddingToScaffold,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              alignment: Alignment.centerLeft,
                                              icon: Icon(
                                                Icons.arrow_back_rounded,
                                                color: Colors.black
                                                    .withOpacity(0.75),
                                                size: 32,
                                              ),
                                              onPressed: model.onBackPressed,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              model.product?.intro ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                            verticalSpaceTiny,
                                            Text(
                                              model.product.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: kMainBlack
                                                          .withOpacity(0.9)),
                                            ),
                                            verticalSpaceMedium,
                                            Text(
                                              '약 ' + model.product.weight,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                            verticalSpaceTiny,
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    getPriceFromInt(
                                                            model.product.price)
                                                        .substring(
                                                            0,
                                                            getPriceFromInt(model
                                                                        .product
                                                                        .price)
                                                                    .length -
                                                                1),
                                                    style: TextStyle(
                                                        color: kMainBlack,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 22,
                                                        letterSpacing: 1.2),
                                                  ),
                                                  SizedBox(width: 1.2),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2),
                                                    child: Text('원',
                                                        style: TextStyle(
                                                            color: kMainBlack,
                                                            fontSize: 18)),
                                                  ),
                                                ])
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ]))),
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              backgroundColor: kMainIvory,
                              elevation: 0, // app bar color
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
                                  indicatorRadius: 30,
                                  insets: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                ),
                                indicatorWeight: 0,
                                labelPadding:
                                    EdgeInsets.symmetric(vertical: 20),
                                tabs: [
                                  MyTabItem(
                                    label: '상세정보',
                                  ),
                                  MyTabItem(
                                    label:
                                        '리뷰(${model.product.ratingsQuantity})',
                                  )
                                ],
                              ),
                            ),
                          ];
                        },
                        body: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            ListView(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: model.product.descriptionImgPath,
                                ),
                              ],
                            ),
                            ReviewsView(reviews: model.product.reviews),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: model.onCartTap,
                        child: Container(
                          height: 70,
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
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kMainPink,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Center(
                                child: Text(
                              "장바구니에 담기",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                              ),
                            )),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
