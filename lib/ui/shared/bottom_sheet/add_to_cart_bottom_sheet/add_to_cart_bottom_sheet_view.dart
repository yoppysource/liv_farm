import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/add_to_cart_bottom_sheet/add_to_cart_bottom_sheet_viewmodel.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/add_to_cart_bottom_sheet/item_list_tile.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/setup_bottom_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../styles.dart';

class AddToCartBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const AddToCartBottomSheetView({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddToCartBottomSheetViewModel>.reactive(
      viewModelBuilder: () =>
          AddToCartBottomSheetViewModel(request.customData['inventoryList']),
      builder: (context, model, child) => GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: model.mapInventoryToQuantity.entries.map((entry) {
                    return ItemListTile(inventory: entry.key, model: model);
                  }).toList(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () =>
                            completer(SheetResponse(confirmed: false)),
                        child: Text(
                          (request.customData['inventoryList'][0].product.category ==
                                      ProductCategory.Dressing ||
                                  request.customData['inventoryList'][0]
                                          .product.category ==
                                      ProductCategory.Protein)
                              ? '선택안함'
                              : '뒤로가기',
                          style: TextStyle(color: kMainPink, fontSize: 18),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FullScreenButton(
                        title: '장바구니에 담기',
                        color: kMainPink,
                        onPressed: () => completer(SheetResponse(
                            confirmed: true,
                            responseData: model.mapInventoryToQuantity)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
