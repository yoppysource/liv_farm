import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/setup_bottom_sheet.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked_services/stacked_services.dart';

class ReviewBottomSheetView extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  final Widget child;

  const ReviewBottomSheetView(
      {Key key, this.request, this.completer, this.child})
      : super(key: key);

  @override
  _WriteBottomSheetViewState createState() => _WriteBottomSheetViewState();
}

class _WriteBottomSheetViewState extends State<ReviewBottomSheetView> {
  final Color buttonTextColor = kMainPink;
  TextEditingController _textEditingController;
  double rating = 5;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "리뷰 작성하기",
              style: Theme.of(context).textTheme.subtitle2,
            ),
            verticalSpaceMedium,
            Center(
              child: RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: kMainPink,
                ),
                onRatingUpdate: (rating) {
                  this.rating = rating;
                },
              ),
            ),
            verticalSpaceMedium,
            TextField(
              scrollPadding: EdgeInsets.zero,
              cursorColor: kMainPink,
              controller: _textEditingController,
              style: Theme.of(context).textTheme.bodyText1,
              maxLength: 50,
              decoration: InputDecoration(
                hintText: "리뷰를 작성해주세요",
                focusColor: kMainPink,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kMainBlack, width: 0.5)),
              ),
              autofocus: true,
            ),
            verticalSpaceMedium,
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () =>
                        widget.completer(SheetResponse(confirmed: false)),
                    child: Text(
                      '뒤로가기',
                      style: TextStyle(color: kMainPink, fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: FullScreenButton(
                    title: '작성하기',
                    color: kMainPink,
                    onPressed: () => widget.completer(
                        SheetResponse(confirmed: true, responseData: {
                      'review': _textEditingController.text,
                      'rating': this.rating,
                    })),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
