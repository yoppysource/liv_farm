import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/styles.dart';

import '../shopping_cart_viewmodel.dart';

class DeliveryOptionCard extends StatelessWidget {
  final ShoppingCartViewModel model;

  const DeliveryOptionCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: '장소선택',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => model.onPressedDeliveryOption(false),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.25,
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                color: model.takeOut ? Colors.white : kMainPink,
                border:
                    Border.all(color: kMainPink.withOpacity(0.95), width: 0.50),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.15,
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Center(
                        child: Icon(
                          Icons.delivery_dining,
                          size: MediaQuery.of(context).size.width * 0.15,
                          color: model.takeOut ? kMainPink : Colors.white,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("배달받기",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: model.takeOut
                                        ? kMainPink
                                        : Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => model.onPressedDeliveryOption(true),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.25,
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                color: model.takeOut ? kMainPink : Colors.white,
                border:
                    Border.all(color: kMainPink.withOpacity(0.95), width: 0.50),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.15,
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Center(
                        child: Icon(
                          FontAwesomeIcons.shoppingBag,
                          size: MediaQuery.of(context).size.width * 0.10,
                          color: model.takeOut ? Colors.white : kMainPink,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "매장찾기",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: model.takeOut
                                        ? Colors.white
                                        : kMainPink),
                          )),
                    ),
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
