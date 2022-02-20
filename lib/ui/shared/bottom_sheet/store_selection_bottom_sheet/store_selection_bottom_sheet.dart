import 'package:flutter/material.dart';
import 'package:liv_farm/model/store.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/setup_bottom_sheet.dart';
import 'package:liv_farm/ui/shared/store_card.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked_services/stacked_services.dart';

class StoreSelectionBottomSheet extends StatelessWidget {
  final SheetRequest<List<Store>> request;
  final Function(SheetResponse<int>) completer;

  const StoreSelectionBottomSheet(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController _controller =
        PageController(viewportFraction: 0.83, initialPage: 0);
    List<Widget> storeCards = [];
    for (int i = 0; i < request.data!.length; i++) {
      Store _store = request.data![i];
      var storeCard = StoreCard(store: _store);
      storeCards.add(storeCard);
    }
    return GestureDetector(
      onVerticalDragDown: (_) {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '상점선택',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 180,
                        child: PageView(
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            children: storeCards),
                      ),
                      verticalSpaceMedium,
                    ],
                  ),
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () =>
                            completer(SheetResponse(confirmed: false)),
                        child: const Text(
                          "취소",
                          style: TextStyle(color: kMainPink, fontSize: 18),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FullScreenButton(
                        title: "선택하기",
                        color: kMainPink,
                        onPressed: () => completer(SheetResponse(
                            confirmed: true, data: _controller.page!.toInt())),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
