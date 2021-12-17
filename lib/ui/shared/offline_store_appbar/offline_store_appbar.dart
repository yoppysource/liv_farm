import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/offline_store_appbar/offline_store_appbar_viewmodel.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

class OfflineStoreAppbarView extends StatelessWidget {
  const OfflineStoreAppbarView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OfflineStoreAppbarViewModel>.reactive(
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
                Center(
                  child: Text(
                    "매장 내 스캔 종료하기",
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: kMainBlack, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                horizontalSpaceTiny,
                Icon(
                  Icons.exit_to_app,
                  color: kMainPink.withOpacity(0.95),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => OfflineStoreAppbarViewModel(),
    );
  }
}
