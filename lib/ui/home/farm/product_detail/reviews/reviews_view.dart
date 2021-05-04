import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/ui/layouts/empty_view.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class ReviewsView extends StatelessWidget {
  final List<Review> reviews;

  const ReviewsView({Key key, this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (reviews == null || this.reviews.isEmpty)
        ? EmptyView(
            iconData: Icons.rate_review_outlined,
            text: "아직 등록된 리뷰가 없습니다",
          )
        : Padding(
            padding: horizontalPaddingToScaffold,
            child: ListView.builder(
              itemCount: this.reviews.length,
              itemBuilder: (context, index) => ReviewCard(
                review: reviews[index],
              ),
            ),
          );
  }
}

class ReviewCard extends StatelessWidget with Formatter {
  final Review review;

  const ReviewCard({Key key, this.review}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title:
          '${review.createdAt == null ? '' : getStringFromDatetime(review.createdAt)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RatingBarIndicator(
                rating: review.rating,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: kMainPink,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
              Text("${review?.userName[0] ?? "김"}** 고객님")
            ],
          ),
          verticalSpaceRegular,
          Text(
            review.review,
            style: Theme.of(context).textTheme.bodyText2,
          )
        ],
      ),
    );
  }
}
