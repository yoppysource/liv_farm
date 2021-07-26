import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/styles.dart';

import '../shopping_cart_viewmodel.dart';

class AddressCard extends StatelessWidget {
  final ShoppingCartViewModel model;

  const AddressCard({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: '배송지 정보',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '주소',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          verticalSpaceSmall,
          GestureDetector(
            onTap: model.onPressedAddress,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: kMainPink.withOpacity(0.95), width: 0.50),
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
                            model.selectedAddress == null
                                ? "주소를 선택해주세요"
                                : '${model.selectedAddress.address} ${model.selectedAddress.addressDetail == null ? "" : model.selectedAddress.addressDetail.length > 7 ? "" : model.selectedAddress.addressDetail}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      width: 25,
                      child: Center(
                        child: Icon(
                          CupertinoIcons.location,
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
          verticalSpaceSmall,
        ],
      ),
    );
  }
}
