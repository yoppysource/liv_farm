
//Product
// product_id	고유 id	Integer	PK, Auto Increment, Not Null	1	X
// category	제품의 카테고리	VARCHAR(45)	N/A	상추/치커리,케일/…	X
// name	제품 이름	VARCHAR(45)	N/A	새우깡	X
// provider_id	공급자 id	Integer	N/A	2	X
// retail_price	판매 가격	Integer	Not Null	10000	O
// location	창고 위치	VARCHAR(45)	N/A	A-20)	X
// description	제품 설명	VARCHAR(255)	N/A		X
// img_path	제품 img경로	VARCHAR(45)	N/A	Server/adming/img/a.png	X
// createdAt	최초 데이터생성날짜	DATETIME	N/A	2020-10-11 00:06:10	X
// updatedAt	마지막 데이터 변경 날짜	DATETIME	N/A	2020-10-11 00:06:10	X
// sku	제품 고유 번호	VARCHAR(45)	N/A	V-L-EZ	X
// name_eng	제품 영어 이름	VARCHAR(45)	N/A	Ezabel Lettuce	X
// Type	상추 종류	VARCHAR(45)	N/A	잎상추	X
// Intro	첫 안내 문구	VARCHAR(45)	N/A	식탁에 더하는 꽃다발	X
// Measure_1	부드러움-아삭함	VARCHAR(45)	N/A		X
// Measure_2	쓴맛-단맛	VARCHAR(45)	N/A		X
// Storage_desc	보관 및 손질/활용	VARCHAR(255)	N/A	문장	X
// Recipe	샐러드 레시피	VARCHAR(255)	N/A	문장	X


const String KEY_productID = 'product_id';
const String KEY_productName = 'name';
const String KEY_productNameInEng = 'name_eng';
const String KEY_productPrice = 'retail_price';
const String KEY_productLocation = 'location';
const String KEY_productDescription = 'description';
const String KEY_imagePath = 'img_path';
const String KEY_productQuantity = 'quantity';
const String KEY_productCategory = 'category';
const String KEY_productIntro = 'intro';
const String KEY_productHardness = 'measure_1';
const String KEY_productTaste = 'measure_2';
const String KEY_productStorageDes = 'storage_desc';
const String KEY_productRecipe = 'recipe';

//purchase
const String KEY_deliveryAddress = 'delivery_address';
const String KEY_deliveryOption = 'delivery_option';
const String KEY_purchaseStatus = 'purchase_status';
const String KEY_orderTimeStamp = 'order_timestamp';

//cart
const String KEY_cartID = 'cart_id';
const String KEY_cartItemID = 'cart_item_id';
const String KEY_cartStatus = 'cart_status';

const String KEY_totalPrice = 'total_price';
const String KEY_amountPriceForCart = 'amount_price';
//asset const

const kLogo = 'assets/images/livLogo.png';

//api const
const apiPrefix = 'http://34.64.245.117:3000/admin/';

//Auth
const String KEY_customer_uid = 'customer_id';
const String KEY_customer_snsId = 'sns_id';
const String KEY_customer_name = 'name';
const String KEY_customer_password = 'password';
const String KEY_customer_email = 'email';
const String KEY_customer_birth = 'birthdate';
const String KEY_customer_detailedAddress = 'detailed_address';
const String KEY_customer_postcode = 'post_code';
const String KEY_customer_address = 'address';
const String KEY_customer_phone = 'phone';
const String KEY_customer_createdate = 'createdate';
const String KEY_customer_createAt = 'createAt';
const String KEY_customer_updatedAt = 'updatedAt';
const String KEY_customer_platform = 'join_platform';
const String KEY_customer_gender = 'gender';
const String KEY_access_token = 'accessToken';
const String MSG = "message";
const String MSG_success =  "success";
const String MSG_fail =  "fail";
const String KEY_Result = 'result';

//Platform
const String Platform_kakao = 'kakao';
const String Platform_apple = 'apple';
const String Platform_facebook = 'facebook';
const String Platform_google = 'google';

//Color
const int kMainColor = 0xff91D833;
const int kSubColorRed = 0xffC5299B;
//review
const String Review_id = 'review_id';
const String Review_customer_id = 'customer_id';
const String Review_product_id ='product_id';
const String Review_rating = 'rating';
const String Review_comment = 'comment';
const String Review_createdAt = 'createdAt';

//const in general

const String IMG_brand = 'assets/images/brand.jpg';

