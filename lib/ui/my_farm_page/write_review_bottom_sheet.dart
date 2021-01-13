import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/ui/shared/platform_widget/my_text_field.dart';
import 'package:liv_farm/ui/shared/toast_msg.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/review_write_bottom_sheet_view_model.dart';
import 'package:provider/provider.dart';

class ReviewWriteBottomSheet extends StatefulWidget {
  final int productId;
  final ReviewWriteBottomSheetViewModel model =
      ReviewWriteBottomSheetViewModel();

  ReviewWriteBottomSheet({Key key, this.productId}) : super(key: key);

  @override
  _ReviewWriteBottomSheetState createState() => _ReviewWriteBottomSheetState();
}

class _ReviewWriteBottomSheetState extends State<ReviewWriteBottomSheet> {
  TextEditingController _reviewController = TextEditingController();
  double rating = 3;

  @override
  void dispose() {
    _reviewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyUser myUser =
        Provider.of<LandingPageViewModel>(context, listen: false).user;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
        ),
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.greenAccent,
          ),
          onRatingUpdate: (r) {
            setState(() {
              rating = r;
            });
          },
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: PlatformTextField(
            hintText: '전달받은 상품은 어떠셨나요? 리뷰를 남겨주세요',
            textInputType: TextInputType.text,
            controller: _reviewController,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
                child: FlatButton(
                    child: Text('닫기'),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
            Expanded(
                child: FlatButton(
              child: Text('제출하기'),
              onPressed: () async {
                Map<String, dynamic> result = await widget.model.submit(Review(
                  customerId: myUser.id,
                  productId: widget.productId,
                  rating: rating,
                  comment: _reviewController.text,
                ));
                if (result[MSG] == MSG_success) {
                  ToastMessage().showReviewSucceedToast();
                  Navigator.pop(context);
                } else {
                  ToastMessage().showReviewFailToast();
                  Navigator.pop(context);
                }
              },
            )),
          ],
        ),
      ],
    );
  }
}
