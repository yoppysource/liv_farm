import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/option_group.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/option_groups_bottom_sheet/option_groups_bottom_sheet_viewmodel.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class OptionsListView extends StatelessWidget {
  const OptionsListView(
      {Key? key,
      required this.optionList,
      this.isForSelectedOption = false,
      required this.model,
      this.groupIndex})
      : super(key: key);

  final List<Option> optionList;
  final bool isForSelectedOption;
  final OptionGroupsBottomSheetViewModel model;
  final int? groupIndex;

  @override
  Widget build(BuildContext context) {
    return ListView(
        scrollDirection: Axis.horizontal,
        children: optionList
            .map((Option option) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: isForSelectedOption
                        ? () {}
                        : () {
                            model.addOption(groupIndex!, option);
                          },
                    child: Stack(
                      children: [
                        Transform(
                          transform: Matrix4.identity()
                            ..translate(2.0, 2.0, 0.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: kDelightPink.withOpacity(0.2),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              border: Border.all(
                                  color: kDelightPink.withOpacity(0.4)),
                              boxShadow: [
                                BoxShadow(
                                  color: kDelightPink.withOpacity(0.4),
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  // shadow direction: bottom right
                                )
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                verticalSpaceTiny,
                                SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: CachedNetworkImage(
                                    imageUrl: option.imagePath,
                                  ),
                                ),
                                verticalSpaceTiny,
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    option.name,
                                    style:
                                        Theme.of(context).textTheme.bodyText2!,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '+${option.price}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          fontSize: 13,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        isForSelectedOption
                            ? Positioned(
                                right: 3,
                                top: 3,
                                child: InkWell(
                                  onTap: () {
                                    model.deleteOption(option);
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                ))
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ))
            .toList());
  }
}
