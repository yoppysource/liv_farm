import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home/shopping_cart/address_select/daum_postcode_search_widget.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class DaumPostcodeSearchView extends StatelessWidget {
  const DaumPostcodeSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(null);
              },
              child: kArrowBack),
        ),
      ),
      body: DaumPostcodeSearchWidget(),
    );
  }
}
