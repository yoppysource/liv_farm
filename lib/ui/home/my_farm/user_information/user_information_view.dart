import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home/my_farm/user_information/user_information_viewmodel.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserInformationView extends StatelessWidget {
  const UserInformationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserInformationViewModel>.reactive(
      builder: (context, model, child) => MyCard(
        title: '회원 정보',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이메일',
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14),
            ),
            verticalSpaceSmall,
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(model.email,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 14)
                                .copyWith(fontSize: 14)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(
                        child: Image.asset(model.logoPathForPlatform),
                      ),
                    )
                  ],
                ),
              ),
            ),
            verticalSpaceSmall,
            Text(
              '성함',
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14),
            ),
            verticalSpaceSmall,
            GestureDetector(
              onTap: model.callBottomSheetToGetName,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: kMainPink, width: 0.4),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 14)),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            size: 20,
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
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14),
            ),
            verticalSpaceSmall,
            GestureDetector(
              onTap: model.callBottomSheetToGetPhoneNumber,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: kMainPink, width: 0.4),
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
                                  .copyWith(letterSpacing: 0.4, fontSize: 14)),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            size: 20,
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
              '성별',
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14),
            ),
            verticalSpaceSmall,
            GestureDetector(
              onTap: () async =>
                  await model.callBottomSheetForSelectingGender(),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                            alignment: Alignment.center,
                            child: model.gender == null
                                ? Icon(
                                    FontAwesomeIcons.question,
                                    size: 21,
                                    color: kMainGrey,
                                  )
                                : model.gender == 'male'
                                    ? Icon(
                                        FontAwesomeIcons.mars,
                                        size: 23,
                                        color:
                                            Colors.blueAccent.withOpacity(0.9),
                                      )
                                    : Icon(FontAwesomeIcons.venus,
                                        size: 23, color: kMainPink)),
                      ),
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: kMainPink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            verticalSpaceSmall,
            Text(
              '생년월일',
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14),
            ),
            verticalSpaceSmall,
            GestureDetector(
              onTap: () async =>
                  await model.callDateTimePickerForBirthDay(context),
              child: Container(
                height: 30,
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
                      Container(
                        width: 25,
                      ),
                      Flexible(
                        child: Text(model.birthday,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.white, fontSize: 14)),
                      ),
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: Center(
                          child: IconButton(
                            onPressed: () {},
                            iconSize: 20,
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
          ],
        ),
      ),
      viewModelBuilder: () => UserInformationViewModel(),
    );
  }
}
