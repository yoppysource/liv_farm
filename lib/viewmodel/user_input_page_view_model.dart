import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kopo/kopo.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/repository/user_information_repository.dart';
import 'package:liv_farm/temp/logger.dart';
import 'package:liv_farm/ui/shared/platform_widget/platform_date_picker.dart';
import 'package:liv_farm/ui/shared/toast_msg.dart';
import 'package:liv_farm/utill/validator.dart';

class UserInputPageViewModel extends InputValidatorsForOrder
    with ChangeNotifier {
  UserInformationRepository _repository = UserInformationRepository();
  MyUser myUser;
  bool isLoading = false;
  bool submitted = false;
  DateTime selectedBirthDate;
  String selectedPostCode;
  String selectedAddress;

  //0이면 남자 1이면 여자
  String selectedGender;

  UserInputPageViewModel(MyUser user) {
    this.myUser = user;
    this.isLoading = false;
    this.selectedBirthDate = DateTime.parse(user.birthday);
    this.selectedPostCode = user.postCode;
    this.selectedAddress = user.address;
    this.selectedGender = user.gender;
  }

  void updateGender() {
    if (selectedGender == 'male') {
      selectedGender = 'female';
    } else {
      selectedGender = 'male';
    }
    log.methodLog(method: 'updateGender noti Called');
    notifyListeners();
  }

  Future<void> updateBirthDate(BuildContext context) async {
    DateTime value = await PlatformDatePicker(
      initialDate: (this.myUser.birthday == null)
          ? DateTime(1993, 09, 08)
          : this.myUser.birthday,
      onDateTimeChanged: (dateTime) {
        selectedBirthDate = dateTime;
        notifyListeners();
      },
    ).show(context);
    if (value != null) {
      selectedBirthDate = value;
      notifyListeners();
    }
  }

  Future<void> updatePostcodeAndAddress(BuildContext context) async {
    KopoModel result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Kopo()));
    if (result != null) {
      selectedAddress = result.address;
      selectedPostCode = result.zonecode;
      notifyListeners();
    }
  }

  Future<void> submitForPersonalInfo({String name, String email}) async {
    myUser.name = name;
    myUser.gender = selectedGender;
    myUser.birthday = selectedBirthDate.toIso8601String();
    myUser.email = email;
    Map<String,dynamic> data = await _repository.updateUserData(
        userData: myUser.toJson(), userId: myUser.id.toString());
    if(data[MSG] == MSG_success){
      ToastMessage().showInfoSuccessToast();
      notifyListeners();
    } else{
      ToastMessage().showErrorToast();
    }
  }
  //
  Future<void> submitForDeliveryInfo({String addressDetail, String phoneNumber}) async {
    myUser.addressDetail = addressDetail;
    myUser.phoneNumber = phoneNumber;
    myUser.address = selectedAddress;
    myUser.postCode = selectedPostCode;
    Map<String,dynamic> data = await _repository.updateUserData(
        userData: myUser.toJson(), userId: myUser.id.toString());
    if(data[MSG] == MSG_success){
      ToastMessage().showInfoSuccessToast();
      notifyListeners();
    } else{
      ToastMessage().showErrorToast();
    }
  }

  //When making type in delivery

  bool get canSubmitWhenOrder {
    return nameValidator.isValid(myUser.name) &&
        addressValidator.isValid(myUser.address) &&
        addressDetailValidator.isValid(myUser.addressDetail) &&
        phoneNumberValidator.isValid(myUser.phoneNumber) &&
        isLoading == false;
  }

  String get nameErrorText {
    bool showErrorText = submitted && !nameValidator.isValid(myUser.name);
    return showErrorText ? invalidErrorText : null;
  }

  String get addressErrorText {
    bool showErrorText = submitted && !addressValidator.isValid(myUser.name);
    return showErrorText ? invalidErrorText : null;
  }

  String get addressDetailErrorText {
    bool showErrorText =
        submitted && !addressDetailValidator.isValid(myUser.name);
    return showErrorText ? invalidErrorText : null;
  }

  String get phoneNumberErrorText {
    bool showErrorText =
        submitted && !phoneNumberValidator.isValid(myUser.name);
    return showErrorText ? invalidErrorText : null;
  }

  Future<void> submitWithCheck() async {
    isLoading = true;
    submitted = true;
    notifyListeners();
    if (canSubmitWhenOrder) {
      // submit();
    }
  }
}
