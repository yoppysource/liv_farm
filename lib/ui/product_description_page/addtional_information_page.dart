import 'package:flutter/material.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/product_description_page/product_description_page.dart';

class AdditionalInformationPage extends StatelessWidget {

  final Product product;

  const AdditionalInformationPage({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [
        LargeText(text: '특징'),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        SmallText(
                          text: '부드러움',
                        ),
                        SmallText(
                          text: '아삭함',
                        ),
                      ],
                    ),
                    SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 1.0,
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 4.0),
                          overlayShape: RoundSliderOverlayShape(
                              overlayRadius: 1.0),
                        ),
                        child: Slider(
                          value: product.productHardness.toDouble(),
                          onChanged: null,
                          max: 5,
                          min: 1,
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        SmallText(
                          text: '단 맛',
                        ),
                        SmallText(
                          text: '쓴 맛',
                        ),
                      ],
                    ),
                    SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 1.0,
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 4.0),
                          overlayShape: RoundSliderOverlayShape(
                              overlayRadius: 1.0),
                        ),
                        child: Slider(
                          value: product.productTaste.toDouble(),
                          onChanged: null,
                          max: 5,
                          min: 1,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        LargeText(text: '${product.productName}, 이렇게 즐겨보세요'),
        SmallText(
          text: product.productRecipe,
        ),
        SizedBox(
          height: 20,
        ),
        LargeText(text: '보관 및 손질'),
        SmallText(
          text: product.productStorageDes,
        ),
      ],
    );
  }
}
