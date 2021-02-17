import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/shared/information_about_company_card.dart';

class AdditionalInformationPage extends StatelessWidget {

  final Product product;

  const AdditionalInformationPage({Key key, this.product}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        CachedNetworkImage(
          imageUrl: product.descriptionImgPath,

          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Container(
                height: 100,
                  width: 100,
                  child: Center(child: CircularProgressIndicator(value: downloadProgress.progress))),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Image.asset('assets/images/brand.jpg'),
        InformationAboutCard(),
        SizedBox(height: 50,),
      ],
    );
  }
}