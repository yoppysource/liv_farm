import 'package:flutter/material.dart';
import 'package:liv_farm/temp/logger.dart';
import 'package:liv_farm/ui/my_farm_page/components/order_status_count.dart';
import 'package:liv_farm/ui/my_farm_page/detailed_purchase_log_page.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/buttons/edit_button.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/text_with_title.dart';
import 'package:liv_farm/ui/shared/title_text.dart';
import 'package:liv_farm/ui/user_input_page/delivery_information_input_page.dart';
import 'package:liv_farm/ui/user_input_page/personal_information_input_page.dart';
import 'package:liv_farm/viewmodel/detailed_purchase_view_model.dart';
import 'package:liv_farm/viewmodel/home_page_view_model.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/my_farm_page_view_model.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:liv_farm/viewmodel/user_input_page_view_model.dart';
import 'package:provider/provider.dart';

class MyFarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log.builderLog(className: 'MyFarmPage Builder called');
    MyFarmPageViewModel _model =
        Provider.of<MyFarmPageViewModel>(context, listen: true);
    final fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(title: '마이 팜'),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: fullWidth * 0.95,
            child: Column(
              children: [
                UserInformationCard(model: _model),
                OrderStatusCard(model: _model),
                AddressInformationCard(model: _model),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddressInformationCard extends StatelessWidget {
  const AddressInformationCard({
    Key key,
    @required MyFarmPageViewModel model,
  })  : _model = model,
        super(key: key);

  final MyFarmPageViewModel _model;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TitleText(text: '배송지 정보'),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWithTitle(
                      title: '우편번호',
                      text: (_model.user?.postCode == null ||
                          _model.user?.postCode == '')
                          ? '우편번호를 입력해 주세요'
                          : _model.user.postCode,
                    ),
                    TextWithTitle(
                      title: '주소',
                      text: (_model.user?.address == null ||
                              _model.user?.address == '')
                          ? '주소를 입력해 주세요'
                          : _model.user.address,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextWithTitle(
                      title: '상세 주소',
                      text: (_model.user?.addressDetail == '' ||
                              _model.user?.addressDetail == null)
                          ? '상세 주소를 입력해 주세요'
                          : _model.user.addressDetail,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextWithTitle(
                      title: '전화번호',
                      text: (_model.user?.phoneNumber == '' ||
                              _model.user?.phoneNumber == null)
                          ? '전화번호를 입력해 주세요'
                          : _model.user.phoneNumber,
                    ),
                  ],
                ),
              ]),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<UserInputPageViewModel>(
                              create: (context) =>
                                  UserInputPageViewModel(_model.user),
                              child: DeliveryInformationInputPage(purpose: DeliveryInformationPurpose.general,)),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserInformationCard extends StatelessWidget {
  const UserInformationCard({
    Key key,
    @required MyFarmPageViewModel model,
  })  : _model = model,
        super(key: key);

  final MyFarmPageViewModel _model;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TitleText(text: '내 정보'),
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
                      text:
                          (_model.user?.name == null || _model.user?.name == '')
                              ? '이름을 입력해 주세요'
                              : _model.user.name,
                    ),
                    TextWithTitle(
                      title: 'Email',
                      text: (_model.user?.email == '' ||
                              _model.user?.email == null)
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
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<UserInputPageViewModel>(
                              create: (context) =>
                                  UserInputPageViewModel(_model.user),
                              child: PersonalInformationInputPage()),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({
    Key key,
    @required MyFarmPageViewModel model,
  })  : _model = model,
        super(key: key);

  final MyFarmPageViewModel _model;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TitleText(text: '주문/배송조회'),
              SizedBox(
                height: 20,
              ),
              _model?.orderCountList == null
                  ? Center(child: CircularProgressIndicator())
                  : OrderStatusCount(
                      numberList: _model.orderCountList,
                    ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '더 보기',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined,
                        size: 13, color: Colors.black54),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => DetailedPurchaseViewmodel(
                          _model.purchaseList,
                          Provider.of<OnlineShoppingViewmodel>(context,
                                  listen: false)
                              .productList),
                      child: DetailedPurchaseLogPage(),
                    ),
                    fullscreenDialog: true,
                  ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
