import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home/shopping_cart/delivery_information/delivery_information_viewmodel.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

class DeliveryInformationView extends StatelessWidget {
  const DeliveryInformationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeliveryInformationViewModel>.reactive(
      builder: (context, model, child) => MyCard(
        title: '주문자 정보',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '성함',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            verticalSpaceSmall,
            GestureDetector(
              onTap: model.callBottomSheetToGetName,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: kMainPink, width: 0.50),
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
                          child: Text(model.name,
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
                            color: kMainPink,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            verticalSpaceSmall,
            Text(
              '연락처',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            verticalSpaceSmall,
            GestureDetector(
              onTap: model.callBottomSheetToGetPhoneNumber,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: kMainPink, width: 0.5),
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
                          child: Text(model.phoneNumber,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(letterSpacing: 0.4)),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            size: 25,
                            color: kMainPink,
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
      ),
      viewModelBuilder: () => DeliveryInformationViewModel(),
    );
  }
}
