import 'package:flutter/material.dart';

class OrderStatusCount extends StatelessWidget {
  final List<int> numberList;

  const OrderStatusCount({Key key, @required this.numberList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatusIndicator(
            icon: Icon(Icons.payment),
            title: '결제완료',
            num: numberList[0],
          ),
        ),
        Expanded(
          child: StatusIndicator(
            icon: Icon(Icons.shopping_bag),
            title: '포장 중',
            num: numberList[1],
          ),
        ),
        Expanded(
          child: StatusIndicator(
            icon: Icon(Icons.delivery_dining),
            title: '배송 중',
            num: numberList[2],
          ),
        ),
        Expanded(
          child: StatusIndicator(
            icon: Icon(Icons.check),
            title: '전달 완료',
            num: numberList[3],
          ),
        ),
        Expanded(
          child: StatusIndicator(
            icon: Icon(Icons.remove),
            title: '환불 처리',
            num: numberList[4],
          ),
        ),
      ],
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final Icon icon;
  final String title;
  final int num;

  const StatusIndicator({Key key, this.icon, this.title, this.num})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: Text(
          '$num',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.grey),
        )),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey),),
      ],
    );
  }
}
