import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/viewmodel/review_page_view_model.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ReviewPageViewModel _model = Provider.of<ReviewPageViewModel>(context,listen: true);
    if(_model.isBusy){
      return Center(
        child: SizedBox(
          height: 100,
            width: 100,
            child: CircularProgressIndicator()),
      );
    }
    else if(_model.reviewList.isEmpty){
      return Center(
        child: Text('등록된 리뷰가 없습니다'),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: _model.reviewList.length,
        itemBuilder: (context, index) => ReviewTile(review: _model.reviewList[index],),
        );
  }
}

class ReviewTile extends StatelessWidget {
  final Review review;

  const ReviewTile({Key key, this.review}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(review.comment, style: TextStyle(fontSize:15),),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      trailing: RatingBarIndicator(
        itemSize: 20,
        rating: review.rating,
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}

