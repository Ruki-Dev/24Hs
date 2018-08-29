import 'package:flutter/material.dart';

class InputFieldArea extends StatelessWidget {
  final String hint;

  final bool obscure;

  final IconData icon;

  final Color hint_color;

  final double fontSize;

  final String fontFamily;

  final Color color;

  final double letterSpacing;

  final double containerHeight;

  final double containerWidth;

  final validator;
  final bool neg_validatorBool;
  final String errMsg;
  final TextEditingController myController;

  InputFieldArea(
      {Key key,
      this.hint,
      this.obscure,
      this.myController,
      this.neg_validatorBool,
      this.errMsg,
      this.validator,
      this.containerWidth,
      this.containerHeight,
      this.letterSpacing,
      this.fontFamily,
      this.color,
      this.icon,
      this.hint_color,
      this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (new Container(
      padding: const EdgeInsets.only(left: 12.0, top: 8.0),
      height: containerHeight,
      width: containerWidth,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
        border: new Border.all(
            color: Colors.midnightAccent, width: 2.5, style: BorderStyle.solid),
        color: Colors.transparent,
      ),
      child: new TextFormField(
        obscureText: obscure,
        controller: myController,
        validator: (validator) {
          if (neg_validatorBool) {
            return errMsg;
          }
        },
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: fontFamily,
          letterSpacing: letterSpacing,
        ),
        decoration: new InputDecoration(
          icon: new Icon(
            icon,
            color: color,
          ),

          border: InputBorder.none,

          hintText: hint,

          hintStyle: TextStyle(color: hint_color, fontSize: fontSize),

          //contentPadding: const EdgeInsets.only(

          //  top: 16.0, right: 12.0, bottom: 16.0, left: 2.0),
        ),
      ),
    ));
  }
}
