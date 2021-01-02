
import 'package:flutter/material.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Placeholder(),
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
              onPressed: () {},
              child: Text(
                '고객센터',
                style: TextStyle(color: Color(0xff153732)),
              )),
          SizedBox(
            height: 5,
          ),
          FlatButton(
              onPressed: () {},
              child: Text('개인정보약관',
                  style: TextStyle(color: Color(0xff153732)))),
          SizedBox(
            height: 5,
          ),
          FlatButton(
              onPressed: () {},
              child: Text('License',
                  style: TextStyle(color: Color(0xff153732)))),
          SizedBox(
            height: 5,
          ),
          FlatButton(
              onPressed: () async {
                await Provider.of<LandingPageViewModel>(context,
                    listen: false)
                    .logout();
              },
              child:
              Text('로그아웃', style: TextStyle(color: Color(0xff153732)))),
        ],
      ),
    );
  }
}
