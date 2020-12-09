import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';

class EditButton extends StatelessWidget {
  final onPressed;

  const EditButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 30,
        width: 73,
        child: MaterialButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Color(kMainColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                    child: Icon(Icons.edit, size: 18,color: Colors.white.withOpacity(0.95),)),
                Expanded(
                  flex: 2,
                    child: Center(child: Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text('수정', style: TextStyle(fontSize: 13,color: Colors.white.withOpacity(0.95)),),
                    ))),
              ],
            ),
            onPressed: onPressed),
      ),
    );
  }
}
