import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

import 'address_appbar_viewmodel.dart';

class AddressAppBarView extends StatelessWidget {
  const AddressAppBarView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddressAppBarViewModel>.reactive(
      builder: (context, model, child) => AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.3,
        title: GestureDetector(
          onTap: () async {
            await model.onPressed();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.location,
                  size: 20,
                  color: kMainGrey,
                ),
                horizontalSpaceSmall,
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      model.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: kMainBlack),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                horizontalSpaceTiny,
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: kMainPink.withOpacity(0.95),
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => AddressAppBarViewModel(),
    );
  }
}
