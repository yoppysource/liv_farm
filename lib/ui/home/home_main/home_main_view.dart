import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/ui/home/home_main/home_main_viewmodel.dart';
import 'package:liv_farm/ui/shared/bubble_painter.dart';
import 'package:liv_farm/ui/shared/information_about_company_card.dart';
import 'package:liv_farm/ui/shared/store_card.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:stacked/stacked.dart';

import 'event_banner/event_banner_viewmodel.dart';

class HomeMainView extends StatelessWidget {
  const HomeMainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ViewModelBuilder<HomeMainViewModel>.reactive(
      builder: (context, model, child) =>
          LayoutBuilder(builder: (context, constraint) {
        final eventBannerHeight = constraint.maxHeight * 0.45;
        return LoadingOverlay(
          isLoading: model.isBusy,
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                SizedBox(
                  height: eventBannerHeight,
                  width: double.infinity,
                  child: const EventBannerView(),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.60,
                  minChildSize: 0.60,
                  expand: true,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  verticalSpaceLarge,
                                  Stack(
                                    children: [
                                      model.showBubbleInformation
                                          ? Positioned(
                                              right: 0,
                                              child: CustomPaint(
                                                painter: BubblePainter(),
                                                child: const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 5,
                                                      left: 5,
                                                      top: 5,
                                                      bottom: 10),
                                                  child: Text(
                                                    "더 가까운 매장이 있어요",
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        color: kDelightPink),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '안녕하세요,\n${model.store.name}입니다',
                                            textAlign: TextAlign.left,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (context) => Dialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                child: SizedBox(
                                                                  height: constraint
                                                                          .maxHeight *
                                                                      0.25,
                                                                  child: Stack(
                                                                    children: [
                                                                      StoreCard(
                                                                        store: model
                                                                            .store,
                                                                        radius:
                                                                            5.0,
                                                                      ),
                                                                      Positioned(
                                                                        child:
                                                                            GestureDetector(
                                                                          child:
                                                                              Text(
                                                                            '확인',
                                                                            style:
                                                                                textTheme.bodyText1!.copyWith(color: Colors.blueAccent),
                                                                          ),
                                                                          onTap:
                                                                              Navigator.of(context).pop,
                                                                        ),
                                                                        bottom:
                                                                            15,
                                                                        right:
                                                                            20,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ));
                                                },
                                                child: const Icon(
                                                  Icons.info_outline,
                                                  color: kDelightPink,
                                                  size: 32,
                                                ),
                                              ),
                                              horizontalSpaceRegular,
                                              ActionChip(
                                                onPressed: () async => await model
                                                    .onPressForChangingStore(),
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                backgroundColor: kDelightPink,
                                                label: Text(
                                                  '매장변경',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                          color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  verticalSpaceLarge,
                                  Text(
                                    '정기구독 서비스',
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  verticalSpaceSmall,
                                  Text(
                                    '리브팜의 신선한 채소를 정기배송으로 만나보세요',
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  verticalSpaceRegular,
                                  Container(
                                    height: 150,
                                    decoration: const BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        )),
                                    child: Center(
                                      child: Text(
                                        '상품 준비중입니다',
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  // verticalSpaceRegular,
                                  // Container(
                                  //   height: 150,
                                  //   decoration: BoxDecoration(
                                  //       color: kMainColor.withOpacity(0.6),
                                  //       borderRadius: const BorderRadius.all(
                                  //         Radius.circular(5.0),
                                  //       )),
                                  // ),
                                  // verticalSpaceRegular,
                                  // Container(
                                  //   height: 150,
                                  //   decoration: BoxDecoration(
                                  //       color: kMainColor.withOpacity(0.6),
                                  //       borderRadius: const BorderRadius.all(
                                  //         Radius.circular(5.0),
                                  //       )),
                                  // ),
                                  verticalSpaceLarge,
                                  Text(
                                    '오늘의 상품',
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  verticalSpaceSmall,
                                  Text(
                                    '파머들이 직접 추천하는 오늘의 상품입니다',
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  verticalSpaceRegular,
                                  SizedBox(
                                    height: 150,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: model.recommendedInventoryList
                                          .map(
                                            (Inventory inventory) =>
                                                RecommendedProductView(
                                              inventory: inventory,
                                              onTap: model.onTapForRecommended,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  verticalSpaceLarge,
                                  Column(
                                    children: const [
                                      InnerText(
                                        title: '(주)퓨처커넥트',
                                        content: '',
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      InnerText(
                                        title: '대표자',
                                        content: '강길모',
                                      ),
                                      InnerText(
                                        title: '사업자등록번호',
                                        content: '801-81-01885',
                                      ),
                                      InnerText(
                                        title: '통신판매업신고번호',
                                        content: '제2021-서울강남-00617호',
                                      ),
                                      InnerText(
                                        title: '배송기간',
                                        content: '즉시배송',
                                      ),
                                      InnerText(
                                        title: '주소',
                                        content: '서울특별시 강남구 테헤란로63길 14, 12층',
                                      ),
                                      InnerText(
                                        title: '대표전화',
                                        content: '02 6081 8179',
                                      ),
                                      InnerText(
                                        title: '이메일',
                                        content: 'admin@livfarm.com',
                                      ),
                                      InnerText(
                                        title: '홈페이지',
                                        content: 'www.livfarm.com',
                                      ),
                                    ],
                                  ),
                                  verticalSpaceLarge,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
      viewModelBuilder: () => HomeMainViewModel(),
    );
  }
}

class RecommendedProductView extends StatelessWidget {
  const RecommendedProductView({
    Key? key,
    required this.inventory,
    required this.onTap,
  }) : super(key: key);

  final Inventory inventory;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {
          onTap(inventory);
        },
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: inventory.product.thumbnailPath,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fadeInDuration: const Duration(milliseconds: 50),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
