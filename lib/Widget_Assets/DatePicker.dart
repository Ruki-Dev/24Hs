import 'package:flutter/material.dart';

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
    this.labelStyle,
    this.labelStyle2,
    this.valueStyle,
    this.validator,
  }) : super(key: key);

  final String labelText;

  final DateTime selectedDate;

  final TextStyle labelStyle;

  final TextStyle labelStyle2;

  final TextStyle valueStyle;

  final FormFieldValidator<String> validator;

  final ValueChanged<DateTime> selectDate;

  // final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(1900, 8),
        lastDate: new DateTime(2019));

    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;

    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            labelStyle: labelStyle,
            labelStyle2: labelStyle2,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.labelStyle,
      this.labelStyle2,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;

  final String valueText;

  final TextStyle valueStyle;

  final TextStyle labelStyle;
  final TextStyle labelStyle2;

  final VoidCallback onPressed;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
            labelText: labelText,
            labelStyle: labelStyle,
            icon: new Icon(
              Icons.cake,
              color: Colors.midnightTextPrimary,
            )),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: labelStyle2),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
