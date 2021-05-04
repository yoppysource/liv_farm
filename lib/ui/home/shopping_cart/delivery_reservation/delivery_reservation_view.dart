import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home/shopping_cart/delivery_reservation/delivery_reservation_viewmodel.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

class DeliveryReservationView extends StatelessWidget {
  const DeliveryReservationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeliveryReservationViewModel>.reactive(
      builder: (context, model, child) => GestureDetector(
        onTap: () async {
          await model.callBottomSheetToGetDateTime();
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: kMainPink,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: model.isBusy
                      ? Center(child: CircularProgressIndicator())
                      : FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(model.message ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.white, fontSize: 17)),
                        ),
                ),
                SizedBox(
                  height: 25,
                  width: 25,
                  child: Center(
                    child: IconButton(
                      onPressed: () {},
                      iconSize: 25,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => DeliveryReservationViewModel(),
    );
  }
}
