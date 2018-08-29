import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twenty_four_hours/Gym/Models/Award.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class AwardDialog extends StatelessWidget {
  final List<dynamic> gold;
  final String type;
  final List<dynamic> silvs;
  final List<dynamic> bronze;

  AwardDialog(this.gold, this.type, this.silvs, this.bronze);

  @override
  Widget build(BuildContext context) {
    if (type == 'gold')
      return new ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: new Text(index.toString()),
            subtitle: new Text(index.toString()),
            leading: new CircleAvatar(
                child: new Icon(false ? FontAwesomeIcons.trophy : Icons.lock,
                    color:
                        false ? Colors.midnightTextPrimary : Colors.white70)),
          );
        },
        itemCount: gold.length,
        itemExtent: 152.0,
      );
    else if (type == 'silver')
      return new ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: new Text(silvs[index].title),
            subtitle: new Text(silvs[index].description),
            leading: new CircleAvatar(
                child: new Icon(
                    silvs[index].achieved
                        ? FontAwesomeIcons.trophy
                        : Icons.lock,
                    color: silvs[index].achieved
                        ? new Color.fromRGBO(191, 191, 191, 1.0)
                        : Colors.white70)),
          );
        },
        itemCount: silvs.length,
        itemExtent: 152.0,
      );
    else
      return new ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: new Text(bronze[index].title),
            subtitle: new Text(bronze[index].description),
            leading: new CircleAvatar(
                child: new Icon(
                    bronze[index].achieved
                        ? FontAwesomeIcons.trophy
                        : Icons.lock,
                    color: bronze[index].achieved
                        ? new Color.fromRGBO(191, 128, 64, 1.0)
                        : Colors.white70)),
          );
        },
        itemCount: bronze.length,
        itemExtent: 152.0,
      );
  }
}
