import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/option_groups_bottom_sheet/option_groups_bottom_sheet_viewmodel.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/option_groups_bottom_sheet/options_list_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/setup_bottom_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../styles.dart';

class OptionGroupsBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const OptionGroupsBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OptionGroupsBottomSheetViewModel>.reactive(
      viewModelBuilder: () =>
          OptionGroupsBottomSheetViewModel(optionGroups: request.data),
      builder: (context, model, child) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: ListView(
            children: [
              Column(children: [
                for (var i = 0; i < model.optionGroups.length; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.optionGroups[i].name} ${model.optionGroups[i].mandatory ? "(필수)" : ""}',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      verticalSpaceRegular,
                      SizedBox(
                        height: 110,
                        child: model.optionGroups[i].options.isEmpty
                            ? Center(
                                child: Text(
                                  "선택가능한 옵션이 없습니다",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              )
                            : OptionsListView(
                                optionList: model.optionGroups[i].options,
                                model: model,
                                groupIndex: i,
                              ),
                      ),
                      verticalSpaceSmall,
                    ],
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '선택된 옵션',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    verticalSpaceRegular,
                    SizedBox(
                      height: 110,
                      child: model.selectedOptions.isEmpty
                          ? Center(
                              child: Text(
                                "선택하신 옵션이 없습니다",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                          : OptionsListView(
                              optionList: model.selectedOptions,
                              isForSelectedOption: true,
                              model: model,
                            ),
                    ),
                  ],
                ),
                verticalSpaceRegular,
              ]),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextButton(
                      onPressed: () =>
                          completer(SheetResponse(confirmed: false)),
                      child: const Text(
                        '뒤로가기',
                        style: TextStyle(color: kMainPink, fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: FullScreenButton(
                      title: model.mainButtonText,
                      enabled: model.isAvailableToSubmit,
                      color: kMainPink,
                      onPressed: () => completer(
                        SheetResponse(
                          confirmed: true,
                          data: model.selectedOptions,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
