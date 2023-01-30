import 'package:flutter/material.dart';

class CusButton extends StatelessWidget {
  const CusButton({Key key, this.onTap, this.text}) : super(key: key);

  final GestureTapCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 130,
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
          child: Row(
            children: [
              Icon(
                Icons.add,
                color: Color(0xff686A6D),
                size: 12,
              ),
              SizedBox(
                width: 2,
              ),
              Flexible(
                child: Text(
                  text ?? '',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
