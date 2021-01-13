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
      List jsonList = data[KEY_Result] as List;
      List<Product> productList = jsonList.map((e) {
        if (e[KEY_productName] != null) {
          return Product.fromJson(data: e);
        }
      }).toList();
      List<Product> tempList =[Product(
        id: 50,
        productName: '닭가슴살',
        productNameInEng: 'chicken breast',
        productPrice: 1000,
        productLocation: '양계',
        productDescription: '닭가슴살닭가슴살닭가슴살닭가슴살닭가슴살닭가슴살닭가슴살닭가슴살닭가슴살닭가슴살',
        imagePath: 'https://images.unsplash.com/photo-1569396327972-6231a5b05ea8?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjZ8fGNoaWNrZW4lMjBicmVhc3R8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
        productCategory: 9,
        productIntro: 'IntroIntroIntroIntroIntroIntro',
        // if quantity is null(when user scan the product initially), should be 1.
        productQuantity: 1,
      ),
      Product(
        id: 51,
        productName: '두부',
        productNameInEng: 'chicken breast',
        productPrice: 1000,
        productLocation: '양계',
        productDescription: '닭가슴살닭가슴살닭가슴살닭가슴살닭가슴살닭가슴살닭가슴살닭가슴살닭가슴살닭가슴살',
        imagePath: 'https://images.unsplash.com/photo-1569396327972-6231a5b05ea8?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjZ8fGNoaWNrZW4lMjBicmVhc3R8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
        productCategory: 9,
        productIntro: 'IntroIntroIntroIntroIntroIntro',
        // if quantity is null(when user scan the product initially), should be 1.
        productQuantity: 1,
      ),
      Product(
        id: 52,
        productName: '소스1',
        productNameInEng: 'sauce1',
        productPrice: 800,
        productLocation: '공장',
        productDescription: '소스소스소스소스소스소스소스소스소스소스소스소스소스소스',
        imagePath: 'https://images.unsplash.com/photo-1472476443507-c7a5948772fc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Mnx8c2F1Y2V8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
        productCategory: 10,
        productIntro: '소스소스소스소스소스소스소스소스',
        // if quantity is null(when user scan the product initially), should be 1.
        productQuantity: 1,
      ),
      Product(
        id: 53,
        productName: '소스2',
        productNameInEng: 'sauce1',
        productPrice: 1000,
        productLocation: '공장',
        productDescription: '소스소스소스소스소스소스소스소스소스소스소스소스소스소스',
        imagePath: 'https://images.unsplash.com/photo-1472476443507-c7a5948772fc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Mnx8c2F1Y2V8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
        productCategory: 10,
        productIntro: '소스소스소스소스소스소스소스소스',
        // if quantity is null(when user scan the product initially), should be 1.
        productQuantity: 1,
      )];

      productList.addAll(tempList);
      return productList;
    }
  }
}