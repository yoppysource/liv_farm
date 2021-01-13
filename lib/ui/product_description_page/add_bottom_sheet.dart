import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/ui/product_description_page/product_description_page.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/toast_msg.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';
import 'package:provider/provider.dart';

class AddBottomSheet extends StatefulWidget {
  final Product product;
  final int inventory;

  const AddBottomSheet({Key key, this.product, this.inventory}) : super(key: key);

  @override
  _AddBottomSheetState createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> with Formatter {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: LargeText(text: '상품 이름'),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            trailing:Padding(
              padding: const EdgeInsets.only(right: 20),
              child: LargeText(text: widget.product.productName,),
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
                        onPressed: (){
                          if(widget.product.productQuantity>=2)
                          setState(() {
                            widget.product.productQuantity -= 1;
                          });
                        }
                        ),
                  ),
                  Expanded(child: Center(child: Text(widget.product.productQuantity.toString()))),
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                        splashRadius: 1,
                        icon: Icon(Icons.add),
                        onPressed: widget.inventory <= widget.product.productQuantity ? () {
                        ToastMessage().showInventoryErrorToast();
                        }:
                            (){
                          setState(() {
                            widget.product.productQuantity += 1;
                          });
                        }
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
          ListTile(
            title: LargeText(text: '총 금액'),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            trailing:Padding(
              padding: const EdgeInsets.only(right: 20),
              child: LargeText(text: getPriceFromInt(widget.product.productQuantity*widget.product.productPrice),),
            ),
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                Expanded(child: FlatButton(
                  child: Text('닫기',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w700),),
                  color: Colors.white,
                  onPressed: (){
                    Navigator.pop(context, false);
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
                    Navigator.pop(context, true);
                  },
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
