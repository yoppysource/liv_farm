import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/product_description_page/product_description_page.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/viewmodel/add_bottom_sheet_view_model.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';
import 'package:provider/provider.dart';

class AddBottomSheet extends StatelessWidget with Formatter {

  @override
  Widget build(BuildContext context) {
    AddBottomSheetViewModel _model = Provider.of<AddBottomSheetViewModel>(context, listen: true);
    return MyCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: LargeText(text: '상품 이름'),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              trailing:Padding(
                padding: const EdgeInsets.only(right: 20),
                child: LargeText(text: _model.selectedProduct.productName,),
              ),
            ),
            ListTile(
              title: LargeText(text: '수량',),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              trailing: Container(
                height: 100,
                width: 100,
                child: Row(
                  children: [
                    Expanded(
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.remove),
                          splashRadius: 1,
                          onPressed: () {_model.removeQuantity(_model.selectedProduct);}
                          ),
                    ),
                    Expanded(child: Center(child: Text('${_model.selectedProduct.productQuantity}'))),
                    Expanded(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                          splashRadius: 1,
                          icon: Icon(Icons.add),
                          onPressed: () {_model.addQuantity(_model.selectedProduct);}
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 0.2,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(color: Colors.black54),
            ),
            if(_model.selectedProduct.productCategory == 1)
            Column(
              children: [
                ListTile(
                  title: LargeText(text: '곁들임'),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                Column(
                  children: List.generate(_model.toppingProductList.length, (index) => AdditionalOptionTile(
    model: _model,
    product: _model.toppingProductList[index],
    )),
                ),
                ListTile(
                  title: LargeText(text: '드레싱'),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                Column(
                  children: List.generate(_model.dressingProductList.length, (index) => AdditionalOptionTile(
                    model: _model,
                    product: _model.dressingProductList[index],
                  )),
                )
              ],
            ),

            Container(
              height: 0.2,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(color: Colors.black54),
            ),
            ListTile(
              title: LargeText(text: '총 금액'),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              trailing:Padding(
                padding: const EdgeInsets.only(right: 20),
                child: LargeText(text: getPriceFromInt(_model.totalPrice)),),
              ),
            Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(child: FlatButton(
                    child: Text('닫기',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w700),),
                    color: Colors.white,
                    onPressed: (){
                      Navigator.pop(context, null);
                    }
                    ,
                  )),
                  Expanded(child: FlatButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text('장바구니에 담기',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
                    ],),
                    color: Color(kSubColorRed),
                    onPressed: (){
                     _model.onPressed();
                      Navigator.of(context).pop(_model.resultList);
                    },
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdditionalOptionTile extends StatelessWidget {

  final AddBottomSheetViewModel model;
  final Product product;

  const AdditionalOptionTile({Key key, this.model, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          LargeText(text: '${product.productName}',),
          FlatButton(
            padding: EdgeInsets.only(top: 3),
              onPressed: (){    Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChangeNotifierProvider(
                    create: (context) =>
                        ProductDescriptionViewmodel(
                          product: product,
                        ),
                    child:  ProductDescriptionPage(),
                  ),
            ),
          );}, child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('상세보기', style: TextStyle(fontSize: 14, color: Colors.grey, ),textAlign: TextAlign.center,),
              Icon(CupertinoIcons.chevron_right, color: Colors.grey, size: 13,)
            ],
          ))
        ],
      ),
      contentPadding: EdgeInsets.only(left: 40, right: 20),
      trailing: Container(
        height: 80,
        width: 100,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.remove),
                  splashRadius: 1,
                  onPressed: () {model.removeQuantity(product);}
              ),
            ),
            Expanded(child: Center(child: Text('${product.productQuantity}'))),
            Expanded(
              child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 1,
                  icon: Icon(Icons.add),
                  onPressed: () {model.addQuantity(product);
                  }

              ),
            ),
          ],
        ),
      ),
    );
  }
}
