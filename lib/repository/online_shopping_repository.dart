import 'package:liv_farm/constant.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/service/api.dart';
import 'package:liv_farm/service/server_service.dart';

class OnlineShoppingRepository {
  ServerService _serverService =
  ServerService(api: API(endpoint: Endpoint.products));


  Future<List> fetchProductListFromServer() async {
    print('function call');
    Map<String, dynamic> data = await _serverService.getData();
    if (data[MSG] == MSG_fail) {
      print('${API.accessToken}');
      print('fail?');
      return List();
    } else {
      print('${data[KEY_Result]}');
      //TODO: 현재 데이터가 준비되어 있지 않아 Mock 데이터로 대체합니다.
      List<Product> productList = List();
      productList.add(Product(id: 1,
          imagePath: 'https://image-placeholder.com/images/actual-size/75x100.png',
          productCategory: 1,
          productDescription: '상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명',
          productHardness: 2,
          productIntro: '상품intro상품intro상품intro상품intro상품intro상품intro', productLocation: '', productName: '로메인 상추', productNameInEng: 'Name in english', productPrice: 100, productRecipe: '상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe', productStorageDes: '상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내',productTaste: 2,productQuantity: 1));
      productList.add(Product(id: 2,
          imagePath: 'https://image-placeholder.com/images/actual-size/75x100.png',
          productCategory: 2,
          productDescription: '상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명',
          productHardness: 4,
          productIntro: '상품intro상품intro상품intro상품intro상품intro상품intro', productLocation: '상품위치', productName: '상품이름', productNameInEng: 'Name in english', productPrice: 300, productRecipe: '상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe', productStorageDes: '상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내',productTaste: 1,productQuantity: 1));
      productList.add(Product(id: 3,
          imagePath: 'https://image-placeholder.com/images/actual-size/75x100.png',
          productCategory: 3,
          productDescription: '상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명',
          productHardness: 1,
          productIntro: '상품intro상품intro상품intro상품intro상품intro상품intro', productLocation: '상품위치', productName: '상품이름', productNameInEng: 'Name in english', productPrice: 100, productRecipe: '상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe', productStorageDes: '상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내',productTaste: 1,productQuantity: 1));
      productList.add(Product(id: 4,
          imagePath: 'https://image-placeholder.com/images/actual-size/75x100.png',
          productCategory: 4,
          productDescription: '상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명',
          productHardness: 1,
          productIntro: '상품intro상품intro상품intro상품intro상품intro상품intro', productLocation: '상품위치', productName: '상품이름/닭가슴', productNameInEng: 'Name in english', productPrice: 200, productRecipe: '상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe', productStorageDes: '상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내',productTaste: 1,productQuantity: 1));
      productList.add(Product(id: 5,
          imagePath: 'https://image-placeholder.com/images/actual-size/75x100.png',
          productCategory: 5,
          productDescription: '상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명상품설명',
          productHardness: 1,
          productIntro: '상품intro상품intro상품intro상품intro상품intro상품intro', productLocation: '상품위치', productName: '드레싱', productNameInEng: 'Name in english', productPrice: 150, productRecipe: '상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe상품recipe', productStorageDes: '상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내상품취급안내',productTaste: 1,productQuantity: 1));
      // List jsonList = data[KEY_Result] as List;
      // List<Product> productList = jsonList.map((e) {
      //   if (e[KEY_productName] != null) {
      //     return Product.fromJson(data: e);
      //   }
      // }).toList();
      return productList;
    }
  }
}