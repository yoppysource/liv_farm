import 'package:flutter/material.dart';

import 'my_card.dart';

class InformationAboutCompanyCard extends StatelessWidget {
  const InformationAboutCompanyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "회사정보",
      child: Column(
        children: const [
          InnerText(
            title: '(주)퓨처커넥트',
            content: '',
          ),
          SizedBox(
            height: 8,
          ),
          InnerText(
            title: '대표자',
            content: '강길모',
          ),
          InnerText(
            title: '사업자등록번호',
            content: '801-81-01885',
          ),
          InnerText(
            title: '통신판매업신고번호',
            content: '제2021-서울강남-00617호',
          ),
          InnerText(
            title: '배송기간',
            content: '즉시배송',
          ),
          InnerText(
            title: '주소',
            content: '서울특별시 강남구 테헤란로63길 14, 12층',
          ),
          InnerText(
            title: '대표전화',
            content: '02 6081 8179',
          ),
          InnerText(
            title: '이메일',
            content: 'admin@livfarm.com',
          ),
          InnerText(
            title: '홈페이지',
            content: 'www.livfarm.com',
          ),
        ],
      ),
    );
  }
}

class InnerText extends StatelessWidget {
  final String title;
  final String content;

  const InnerText({Key? key, required this.title, required this.content})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          content,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
