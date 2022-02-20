import 'package:liv_farm/model/option_group.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:stacked/stacked.dart';

class OptionGroupsBottomSheetViewModel extends BaseViewModel {
  OptionGroupsBottomSheetViewModel({required this.optionGroups});
  final List<OptionGroup> optionGroups;
  final List<Option> selectedOptions = [];

  bool get isAvailableToSubmit {
    List<OptionGroup> mandatoryGroups = optionGroups
        .where((OptionGroup element) => element.mandatory == true)
        .toList();
    if (mandatoryGroups.isEmpty) return true;
    for (OptionGroup optionGroup in mandatoryGroups) {
      bool isNotContained = optionGroup.options
          .every((element) => !selectedOptions.contains(element));
      if (isNotContained) return false;
    }
    return true;
  }

  String get mainButtonText {
    if (!isAvailableToSubmit) return "필수옵션을 선택해주세요";
    if (selectedOptions.isEmpty) {
      return "추가 옵션 없음";
    } else {
      int sum = 0;
      for (var option in selectedOptions) {
        sum += option.price;
      }
      return "옵션 선택(+$sum)";
    }
  }

  void addOption(int groupIndex, Option option) {
    if (!selectedOptions.contains(option)) {
      if (!optionGroups[groupIndex].multiSelectable) {
        optionGroups[groupIndex].options.forEach(selectedOptions.remove);
      }
      selectedOptions.add(option);
      notifyListeners();
    } else {
      ToastMessageService.showToast(message: "이미 추가된 옵션입니다");
    }
  }

  void deleteOption(Option option) {
    selectedOptions.remove(option);
    notifyListeners();
  }
}
