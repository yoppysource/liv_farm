import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../setup_bottom_sheet.dart';

class CustomerServiceBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const CustomerServiceBottomSheetView(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '고객센터',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              verticalSpaceMedium,
              Padding(
                padding: horizontalPaddingToScaffold,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '운영시간',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          "09:00 ~ 21:00",
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                    verticalSpaceMedium,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '전화',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        GestureDetector(
                            onTap: () async {
                              String url = "tel://0260818179";
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                return;
                              }
                            },
                            child: Text(
                              '02-6081-8179',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      textBaseline: TextBaseline.alphabetic),
                            )),
                      ],
                    ),
                    verticalSpaceMedium,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '이메일',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          "admin@livfarm.com",
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                    verticalSpaceMedium,
                  ],
                ),
              ),
              verticalSpaceMedium,
              FullScreenButton(
                title: '확인',
                color: kMainPink,
                onPressed: () => completer(SheetResponse(
                  confirmed: true,
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
