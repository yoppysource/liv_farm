import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/buttons/edit_button.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/text_with_title.dart';
import 'package:liv_farm/ui/shared/title_text.dart';
import 'package:liv_farm/ui/user_input_page/personal_information_input_page.dart';
import 'package:liv_farm/viewmodel/my_farm_page_view_model.dart';
import 'package:liv_farm/viewmodel/user_input_page_view_model.dart';
import 'package:provider/provider.dart';

class UserInformationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyFarmPageViewModel _model = Provider.of(context, listen: true);
    return MyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(text: '내 정보'),
              EditButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<UserInputPageViewModel>(
                              create: (context) =>
                                  UserInputPageViewModel(_model),
                              child: PersonalInformationInputPage()),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(children: [
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWithTitle(
                  title: '이름',
                  text: (_model.user?.name == null || _model.user?.name == '')
                      ? '이름을 입력해 주세요'
                      : _model.user.name,
                ),
                TextWithTitle(
                  title: 'Email',
                  text: (_model.user?.email == '' || _model.user?.email == null)
                      ? '이메일을 입력해 주세요'
                      : _model.user.email,
                ),
              ],
            ),
          ]),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}