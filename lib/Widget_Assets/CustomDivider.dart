import 'package:flutter/material.dart';

enum Direction{Vertical,Horizontal}
class CustomDivider extends StatelessWidget
{
  final Direction orientation;
  final double length;
  final double thickness;
  final Color color;
  CustomDivider({this.color,this.orientation=Direction.Horizontal,length=double.infinity,thickness=3.0});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return orientation==Direction.Vertical?Container(
      height: length,
      width: thickness,
      color: color,
      margin: const EdgeInsets.only(left:10.0,right: 10.0),

    ):Container(
      height: thickness,
      width: length,
      color: color,
      margin: const EdgeInsets.only(left:10.0,right: 10.0),

    );
  }

}