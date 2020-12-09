import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/ui/farm_video_page.dart';
import 'package:liv_farm/ui/shared/buttons/in_app_button.dart';
import 'package:liv_farm/ui/shared/buttons/refresh_button.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/platform_exception_alert_dialog.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:provider/provider.dart';

class OnlineShoppingPage extends StatefulWidget  {
  @override
  _OnlineShoppingPageState createState() => _OnlineShoppingPageState();
}

class _OnlineShoppingPageState extends State<OnlineShoppingPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: index);
    Provider.of<OnlineShoppingViewmodel>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    OnlineShoppingViewmodel _model =
        Provider.of<OnlineShoppingViewmodel>(context, listen: true);
    //List must be checked with isEmpty method.
    if (_model.productList == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_model.productList.isEmpty) {
      PlatformExceptionAlertDialog(
              title: '서버 오류', content: '데이터 정보를 가져오는데 실패했습니다.')
          .show(context);
      return Scaffold(
        body: Center(
          child: RefreshButton(onPressed: () async => _model.init()),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Liv Farm',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: DefaultTabController(
          length: 4,
          initialIndex: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Text('   Just harvested',style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 20,
                color: Colors.blueGrey.withOpacity(0.8),
                fontWeight: FontWeight.w700,
              ),),
              SizedBox(height: 2,),
              Text('   in your neighborhood',style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 20,
                color: Colors.blueGrey.withOpacity(0.8),
                fontWeight: FontWeight.w700,
              ),),
              SizedBox(height: 30,),
              TabBar(
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey,letterSpacing: 1, fontSize:13),
                  labelStyle: TextStyle(fontWeight: FontWeight.w700, color: Colors.black54, letterSpacing: 1, fontSize: 15),
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3.0, color: Color(kMainColor)),
                      insets: EdgeInsets.symmetric(horizontal: 40)),
                  controller: _tabController,
                  tabs: [
                    Tab(
                      child: Text(
                        'Liv Farm',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '샐러드',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '채소',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '샘플러',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ]),
              SizedBox(height: 30,),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  Container(
                    child: Text('Liv Farm Page'),
                  ),
                  Container(
                    child: Text('Salad'),
                  ),
                  GridView.builder(
                    itemCount: _model.productList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ProductDescriptionPage(
                      //           callBackForSuccess: callBackForSuccess,
                      //           product: product,
                      //         )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0.1,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.27,
                                  child: Image.network(
                                    '${_model.productList[index].imagePath}',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text(
                                    '${_model.productList[index].name}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black.withOpacity(0.8)),
                                  ),
                                  Text('${_model.productList[index].location}'),
                                  Text('${Formatter().getPriceFromInt(_model.productList[index].price)}')
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),),
                  Container(
                    child: Text('Sampler'),
                  ),
                ]),
              )
            ],
          ),
        ),
      );
    }
  }
}
