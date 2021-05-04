import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/ui/home/shopping_cart/address_select/address_select_viewmodel.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

class AddressSelectView extends StatelessWidget {
  const AddressSelectView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddressSelectViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child:
                GestureDetector(onTap: model.onPressedBack, child: kArrowBack),
          ),
        ),
        body: ListView(
          children: [
            Container(
              height: 50,
              color: Colors.white,
              child: Padding(
                padding: horizontalPaddingToScaffold,
                child: InkWell(
                  onTap: model.onPressedSearch,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.search,
                        color: Colors.black.withOpacity(0.75),
                        size: 25,
                      ),
                      horizontalSpaceSmall,
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '도로명 건물명 또는 지번으로 검색하기',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            verticalSpaceSmall,
            Container(
                height: 150,
                color: Colors.white,
                child: model.addresses.isEmpty
                    ? Center(
                        child: Text(
                        '배송지를 추가해주세요',
                        style: Theme.of(context).textTheme.bodyText2,
                      ))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: model.addresses.length,
                        itemBuilder: (context, index) => AddressListTile(
                          address: model.addresses[index],
                          index: index,
                          model: model,
                        ),
                      )),
            verticalSpaceSmall,
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child:
                    Image.asset('assets/images/delivery_possible_image.jpeg'),
              ),
            ),
            verticalSpaceSmall,
          ],
        ),
      ),
      viewModelBuilder: () => AddressSelectViewModel(),
    );
  }
}

class AddressListTile extends StatelessWidget {
  final Address address;
  final int index;
  final AddressSelectViewModel model;

  const AddressListTile({Key key, this.address, this.index, this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Padding(
          padding: horizontalPaddingToScaffold,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => model.onPressedAddressTile(this.index),
                child: Icon(
                  CupertinoIcons.check_mark,
                  color: index == 0 ? kMainPink : Colors.transparent,
                ),
              ),
              horizontalSpaceSmall,
              Expanded(
                child: GestureDetector(
                  onTap: () => model.onPressedAddressTile(this.index),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${address.address} ${address?.addressDetail ?? ""}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: kMainBlack),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              horizontalSpaceSmall,
              InkWell(
                onTap: () => model.onPressedDelete(this.index),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: kMainGrey,
                ),
              ),
            ],
          ),
        ));
  }
}