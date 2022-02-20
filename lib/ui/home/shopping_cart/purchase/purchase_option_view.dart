import 'package:flutter/material.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class PurchaseOptionView extends StatelessWidget with Formatter {
  final String orderName;
  final int amount;
  final Address? address;
  final String orderRequestMessage;
  final String bookingOrderMessage;
  final String option;

  const PurchaseOptionView(
      {Key? key,
      required this.orderName,
      required this.amount,
      this.address,
      required this.orderRequestMessage,
      required this.option,
      required this.bookingOrderMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결제하기',
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(fontWeight: FontWeight.normal)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: horizontalPaddingToScaffold,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                MyCard(
                  title: '주문 확인',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConfirmOrderListTile(
                        title: '주문명',
                        content: orderName,
                      ),
                      verticalSpaceRegular,
                      ConfirmOrderListTile(
                        title: '수령 방법',
                        content: option == 'inStore'
                            ? "매장 내 구매"
                            : option == 'delivery'
                                ? '배달받기'
                                : '매장에서 찾기',
                      ),
                      verticalSpaceRegular,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '결제 금액',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: kMainGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                          ),
                          Text(
                            getPriceFromInt(amount),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: kMainBlack,
                                    fontSize: 16,
                                    letterSpacing: 0.7),
                          ),
                        ],
                      ),
                      verticalSpaceRegular,
                      if (option == 'delivery')
                        Column(
                          children: [
                            ConfirmOrderListTile(
                                title: '주소', content: address!.address),
                            verticalSpaceRegular,
                            ConfirmOrderListTile(
                                title: '상세주소',
                                content: address!.addressDetail ?? ' '),
                            verticalSpaceRegular,
                          ],
                        ),
                      if (option != 'inStore')
                        ConfirmOrderListTile(
                            title: '배송/포장 메세지', content: orderRequestMessage),
                      verticalSpaceRegular,
                      if (option != 'inStore')
                        ConfirmOrderListTile(
                          title: '수령 시간',
                          content: bookingOrderMessage,
                        ),
                    ],
                  ),
                ),
                verticalSpaceLarge,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop("kakaopay");
                  },
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xffF7E600),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text("카카오페이로 결제하기",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyText1),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset("assets/images/kakao_icon.png"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                verticalSpaceMedium,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop("html5_inicis");
                  },
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: kMainPink.withOpacity(0.95), width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("카드로 결제하기",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyText1),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: Center(
                              child: Icon(
                                Icons.credit_card,
                                size: 25,
                                color: kMainPink.withOpacity(0.95),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmOrderListTile extends StatelessWidget {
  final String content;
  final String title;

  const ConfirmOrderListTile(
      {Key? key, required this.content, required this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: kMainGrey, fontSize: 16, fontWeight: FontWeight.normal),
        ),
        Flexible(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(content,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1),
          ),
        ),
      ],
    );
  }
}
