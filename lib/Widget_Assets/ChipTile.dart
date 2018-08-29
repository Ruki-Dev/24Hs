import 'package:flutter/material.dart';

class ChipTile extends StatelessWidget {
  const ChipTile({
    Key key,
    this.label,
    this.children,
  }) : super(key: key);

  final String label;

  final List<Widget> children;

  // Wraps a list of chips into a ListTile for display as a section in the demo.

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
        child: new Text(label, textAlign: TextAlign.start),
      ),
      subtitle: children.isEmpty
          ? new Center(
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  'None',
                  style: Theme
                      .of(context)
                      .textTheme
                      .caption
                      .copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            )
          : new Wrap(
              children: children
                  .map((Widget chip) => new Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: chip,
                      ))
                  .toList(),
            ),
    );
  }
}
