import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductDescriptionViewmodel _model =
        Provider.of<ProductDescriptionViewmodel>(context, listen: true);
    if (_model.isLazyLoaded == false) {
      return SizedBox(
          height: 500,
          width: 100,
          child: Center(child: CircularProgressIndicator()));
    } else if (_model.reviewList.isEmpty) {
      return SizedBox(
          height: 500, width: 100, child: Center(child: Text('등록된 리뷰가 없습니다')));
    }
    else{
    return ConstrainedBox(
      constraints: new BoxConstraints(
        minHeight: 500,
        maxHeight: double.infinity,
      ),

      child: Column(
        children: _model.reviewList.map((e) => ReviewTile(review: e,)).toList()
        ,
      ),
    );
    }
  }
}

class ReviewTile extends StatelessWidget with Formatter {
  final Review review;

  const ReviewTile({Key key, this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${getStringFromDatetime(review.createAt)}'),
                RatingBarIndicator(
                  itemSize: 20,
                  rating: review.rating,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Color(kSubColorRed),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              review.comment,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );

    //   ListTile(
    //
    //   title: Text(review.comment, style: TextStyle(fontSize:15),),
    //   contentPadding: EdgeInsets.symmetric(horizontal: 20),
    //   trailing: RatingBarIndicator(
    //     itemSize: 20,
    //     rating: review.rating,
    //     itemBuilder: (context, _) => Icon(
    //       Icons.star,
    //       color: Colors.greenAccent,
    //     ),
    //   ),
    // );
  }
}
