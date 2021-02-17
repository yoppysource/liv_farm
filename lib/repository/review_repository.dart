
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/review.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';

class ReviewRepository {

  ServerService _getReviewService = ServerService(api: API(endpoint: Endpoint.reviewGet));
  ServerService _postReviewService = ServerService(api: API(endpoint: Endpoint.reviewPost));
  Future getReviewData(int productId) async {
   Map result = await _getReviewService.getData(params1: '/$productId}');

    if (result[MSG] == MSG_success) {
      print(result.toString());
      List<dynamic> reviewMapList = result[KEY_Result].cast() as List;
      if (reviewMapList.isEmpty) {
        print('isempty!');
        return List<Review>();
      }
      List<Review> reviewList = reviewMapList
          .map((i) => Review.fromJson(i))
          .toList()
          .reversed
          .toList();
      return reviewList;
    } else {
      return  List<Review>();
    }
  }

  Future<Map> postReviewData(Review review) async {

    return await _postReviewService.postData(data: review.toJson());
  }
}
