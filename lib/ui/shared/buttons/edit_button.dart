import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final onPressed;

  const EditButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Container(
        height: 30,
        width: 70,
        child: MaterialButton(
            padding: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Color(0xffC5299B).withOpacity(0.85),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 12,
                ),
                Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.white,
                ),
                Text(
                  '수정',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
              ],
            ),
            onPressed: onPressed),
      ),
    );
  }
}
