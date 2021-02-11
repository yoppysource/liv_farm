import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/product_description_page/product_description_page.dart';

class BasicDescriptionPage extends StatelessWidget with Formatter {
  final Product product;
  final int inventory;

  const BasicDescriptionPage({Key key, this.product, this.inventory}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Hero(
              tag: '${product.id}',
              child: Container(
                color: Colors.white,
                  height: MediaQuery.of(context).size.width *
                      1*1.2,
                  width:
                  MediaQuery.of(context).size.width * 1.0,
                  child: CachedNetworkImage(
                    imageUrl: product.imagePath,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => Image(image: CachedNetworkImageProvider(product.thumbnailPath),fit: BoxFit.fitWidth,),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
             Text(
               product.productName, style: Theme.of(context).textTheme.subtitle1,
             ),
              Text(
               product.productIntro, style: Theme.of(context).textTheme.bodyText2,
              ),

              SizedBox(
                height: 20,
              ),
            //TODO: 상품 몇 그람인지, 몇송이인지, 관련 정보 업데이
            Text(
              '30g(한 송이)', style: Theme.of(context).textTheme.bodyText2,
            ),
              SizedBox(
                height: 1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getPriceFromInt(product.productPrice).substring( 0, getPriceFromInt(product.productPrice).length-1),style: TextStyle(color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.w700, fontSize:22, letterSpacing: 1.2),
                  ),
                  SizedBox(width: 1.2),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text('원', style: TextStyle(color: Colors.black.withOpacity(0.9), fontSize:18)),
                  ),
                ],
              ),
              if(this.inventory !=null && this.inventory <1)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SmallText(
                      text: '상품이 품절되었습니다'),
                ),
                SizedBox(
                  height: 20,
                ),

            ],
          ),
        ),
      ],
    );
  }
}

class ProductDescriptionLargeText extends StatelessWidget {
  final String text;

  const ProductDescriptionLargeText({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text, style: TextStyle(color: Colors.black, fontSize: 20),
    );
  }
}
