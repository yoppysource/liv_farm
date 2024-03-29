import 'package:badges/badges.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/cart.dart';
import 'package:liv_farm/model/order.dart';
import 'package:liv_farm/ui/home/order_history/order_history_viewmodel.dart';
import 'package:liv_farm/ui/layouts/empty_view.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/my_tap_item.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:stacked/stacked.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({Key? key}) : super(key: key);

  @override
  _OrderHistoryViewState createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView>
    with SingleTickerProviderStateMixin, Formatter {
  late ScrollController _scrollViewController;
  late TabController _tabController;
  @override
  void initState() {
    _scrollViewController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderHistoryViewModel>.reactive(
      builder: (context, model, child) => LoadingOverlay(
        progressIndicator: const CircularProgressIndicator(),
        isLoading: model.isBusy,
        color: kMainGrey,
        child: SafeArea(
          child: Padding(
            padding: horizontalPaddingToScaffold,
            child: NestedScrollView(
              controller: _scrollViewController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
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
                        insets: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                      ),
                      indicatorWeight: 0,
                      labelPadding: const EdgeInsets.symmetric(vertical: 20),
                      tabs: const [
                        MyTabItem(
                          label: '진행 중',
                        ),
                        MyTabItem(
                          label: '완료 내역',
                        )
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  model.yetCompleteOrderList.isEmpty
                      ? const EmptyView(
                          iconData: CupertinoIcons.square_favorites_alt,
                          text: "진행 중인 주문 내역이 없습니다",
                        )
                      : RefreshIndicator(
                          onRefresh: model.futureToRun,
                          displacement: 20,
                          color: kMainPink,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.yetCompleteOrderList.length,
                              itemBuilder: (context, index) {
                                Order order = model.yetCompleteOrderList[index];
                                return OrderCard(
                                  order: order,
                                  isCurrentOrder: true,
                                  model: model,
                                );
                              }),
                        ),
                  model.completeOrderList.isEmpty
                      ? const EmptyView(
                          iconData: CupertinoIcons.check_mark,
                          text: "완료된 주문 내역이 없습니다",
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: model.completeOrderList.length,
                          itemBuilder: (context, index) {
                            Order order = model.completeOrderList[index];
                            return OrderCard(
                              order: order,
                              isCurrentOrder: false,
                              model: model,
                            );
                          }),
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => OrderHistoryViewModel(),
    );
  }
}

class OrderCard extends StatelessWidget with Formatter {
  final OrderHistoryViewModel model;
  final Order order;
  final bool isCurrentOrder;

  const OrderCard(
      {Key? key,
      required this.order,
      required this.isCurrentOrder,
      required this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: MyCard(
        title: order.createdAt == null
            ? ''
            : getStringFromDatetime(order.createdAt!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              order.orderStatus,
              style: const TextStyle(
                color: kMainGrey,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            verticalSpaceRegular,
            ListView.separated(
              itemCount: order.cart.items.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Item _item = order.cart.items[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: CachedNetworkImage(
                            imageUrl: _item.inventory.product.thumbnailPath,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fadeInDuration: const Duration(milliseconds: 50),
                            fit: BoxFit.cover,
                          ),
                        ),
                        horizontalSpaceRegular,
                        SizedBox(
                          height: 100,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(_item.inventory.product.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ),
                                  Text(
                                    '구매수량 | ${_item.quantity}개',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                              Text(
                                  getPriceFromInt(
                                      _item.inventory.product.price),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceSmall,
                    isCurrentOrder == true
                        ? Container()
                        : SizedBox(
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    child: Badge(
                                      badgeColor: kMainColor.withOpacity(0.9),
                                      shape: BadgeShape.square,
                                      elevation: 0.5,
                                      position: BadgePosition.topEnd(),
                                      borderRadius: BorderRadius.circular(10),
                                      padding:
                                          (!order.isReviewed && !isCurrentOrder)
                                              ? const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 2)
                                              : EdgeInsets.zero,
                                      badgeContent:
                                          (!order.isReviewed && !isCurrentOrder)
                                              ? const Text(
                                                  "리뷰를 작성해 주세요",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                )
                                              : Container(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.5,
                                              color: order.isReviewed
                                                  ? kMainBlack
                                                  : kMainColor),
                                        ),
                                        child: Center(
                                            child: Text(
                                          '리뷰 작성',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                  color: order.isReviewed
                                                      ? kMainBlack
                                                      : kMainColor),
                                        )),
                                      ),
                                    ),
                                    onTap: () async => await model.createReview(
                                        _item.inventory.product.id, order.id),
                                  ),
                                ),
                                horizontalSpaceRegular,
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: kMainBlack),
                                      ),
                                      child: Center(
                                          child: Text(
                                        '재구매',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      )),
                                    ),
                                    onTap: () {
                                      model.navigateToProductDetail(
                                          _item.inventory);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                    verticalSpaceSmall,
                  ],
                );
              },
              separatorBuilder: (context, index) => Container(),
            ),
            if (isCurrentOrder == true)
              Column(
                children: [
                  if (order.option == 'delivery')
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '배송지',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                  color: kMainGrey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                        ),
                        verticalSpaceTiny,
                        Text(
                          "${order.address.address} ${order.address.addressDetail ?? ""}",
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                      ],
                    ),
                  verticalSpaceSmall,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '수령예정시간',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: kMainGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                      verticalSpaceTiny,
                      Text(
                        order.bookingOrderMessage?.toString() ?? '',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  const Divider(
                    height: 5,
                    thickness: 2,
                    color: kMainLightPink,
                  ),
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '결제 금액',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: kMainGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        getPriceFromInt(order.paidAmount),
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: kMainBlack,
                            fontSize: 16,
                            letterSpacing: 0.7),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
