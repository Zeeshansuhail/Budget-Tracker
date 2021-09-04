import 'package:flutter/cupertino.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const Indicator({Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 16.0,
          width: 16.0,
          color: color,
        ),
        SizedBox(
          width: 4.0,
        ),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
