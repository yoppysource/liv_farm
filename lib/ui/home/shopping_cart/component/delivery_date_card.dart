import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home/shopping_cart/booking_order/booking_order_view.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class DeliveryDateCard extends StatelessWidget {
  final ShoppingCartViewModel model;

  const DeliveryDateCard({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: '시간선택',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.takeOut? '언제 매장에서 찾으시겠어요?': '언제 배송을 받아보시겠어요?',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          verticalSpaceSmall,
          BookingOrderView(
            model: model,
          ),
          verticalSpaceSmall,
          verticalSpaceSmall,
          Text(
            model.takeOut? '포장 시 요청사항이 있으신가요?':  '배송 시 요청사항이 있으신가요?',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          verticalSpaceSmall,
          GestureDetector(
            onTap: model.callBottomSheetToGetInput,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: kMainPink.withOpacity(0.95), width: 0.5),
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
                        child: Text(
                            model.deliveryRequestMessage == ''
                                ? model.takeOut? '예) 뿌리는 제거해주세요' : '예) 문 앞에 두고 가주세요'
                                : model.deliveryRequestMessage,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      width: 25,
                      child: Center(
                        child: Icon(
                          Icons.edit,
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
    );
  }
}
