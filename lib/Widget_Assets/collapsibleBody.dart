import 'package:flutter/material.dart';

class CollapsibleBody extends StatelessWidget {
  const CollapsibleBody(
      {this.margin = EdgeInsets.zero, this.child, this.onSave, this.onCancel});

  final EdgeInsets margin;

  final Widget child;

  final VoidCallback onSave;

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final TextTheme textTheme = theme.textTheme;

    return new Column(children: <Widget>[
      new Container(
          margin: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0) -
              margin,
          child: new Center(
              child: new DefaultTextStyle(
                  style: textTheme.caption.copyWith(fontSize: 15.0),
                  child: child))),
      const Divider(height: 1.0),
      new Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: new FlatButton(
                        onPressed: onCancel,
                        child: const Text('CANCEL',
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500)))),
                new Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: new FlatButton(
                        onPressed: onSave,
                        textTheme: ButtonTextTheme.accent,
                        child: const Text('SAVE')))
              ]))
    ]);
  }
}
