import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  final Color color;
  final Decoration headerDecoration;
  final Color lighttextColor;
  final Color darktextColor;
  final String headerText;
  final String headerText2;
  final String fontFamily;
  final double fontSize;
  final bool headerImage = false;
  final String coverurl;

  const NavigationDrawer(@required headerImage,
      {this.color,
      this.headerDecoration,
      this.lighttextColor,
      this.darktextColor,
      this.headerText,
      this.headerText2,
      this.fontFamily,
      this.fontSize,
      this.coverurl});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: headerImage
                ? new Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage('images/ic_launcher.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: new Column(
                      children: <Widget>[
                        Text(
                          headerText != null ? headerText : '',
                          style: new TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSize,
                              color: lighttextColor),
                        ),
                      ],
                    ),
                  )
                : new Container(
                    color: color,
                    child: new Column(
                      children: <Widget>[
                        Text(
                          headerText != null ? headerText : '',
                          style: new TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSize,
                              color: lighttextColor),
                        ),
                      ],
                    ),
                  ),
            decoration: headerDecoration,
          ),
          ListTile(
            title: new Row(
              children: <Widget>[
                new Icon(Icons.calendar_today, color: darktextColor),
                new Text(
                  'Calendar',
                  style:
                      new TextStyle(fontFamily: fontFamily, fontSize: fontSize),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
