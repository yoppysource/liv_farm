import 'package:flutter/material.dart';

import 'package:iamport_flutter/iamport_certification.dart';
/* 아임포트 휴대폰 본인인증 데이터 모델을 불러옵니다. */
import 'package:iamport_flutter/model/certification_data.dart';

class CertificationView extends StatelessWidget {
  const CertificationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IamportCertification(
      appBar: new AppBar(
        title: new Text('아임포트 본인인증'),
      ),
      /* 웹뷰 로딩 컴포넌트 */
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      ),
      /* [필수입력] 가맹점 식별코드 */
      userCode: 'imp87654969',
      /* [필수입력] 본인인증 데이터 */
      data: CertificationData.fromJson({
        'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
        'company': '아임포트', // 회사명 또는 URL
        'carrier': 'SKT', // 통신사
        'name': '이준엽', // 이름
        'phone': '01094764622', // 전화번호
      }),
      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) {
        print(result.toString());
        // Navigator.of(context).pop(result);
      },
    );
  }
}
