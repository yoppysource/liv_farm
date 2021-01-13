import 'package:flutter/material.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/product_description_page/product_description_page.dart';

class AdditionalInformationPage extends StatelessWidget {

  final Product product;

  const AdditionalInformationPage({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
        child: Image.asset('assets/images/sample.png'));
  }
}