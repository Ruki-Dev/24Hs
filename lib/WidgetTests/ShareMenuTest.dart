import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';

void main() {
  runApp(new MaterialApp(
    title: 'twentyfourhours',
    routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => new _MainScreen(),
      '/Home': (BuildContext context) => new _DynamicLinkScreen(),
    },
  ));
}

class _MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MainScreenState();
}

class _MainScreenState extends State<_MainScreen> {
  String _linkMessage;
  bool _isCreatingLink = false;

  @override
  BuildContext get context => super.context;

  @override
  void initState() {
    super.initState();
    _retrieveDynamicLink();
  }

  Future<void> _retrieveDynamicLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.retrieveDynamicLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = new DynamicLinkParameters(
      domain: '24hours.page.link',
      link: Uri.parse('https://24hours.page.link/Home'),
      androidParameters: new AndroidParameters(
        packageName: 'com.rookieplays.main24hours',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: new DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: new IosParameters(
        bundleId: 'com.rookieplays.main24hours',
        minimumVersion: '0',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
      Share.share(
        _linkMessage ?? 'Hi This is a Remote Mesage from a different app',
        //sharePositionOrigin:
        //box.localToGlobal(Offset.zero) &
        //box.size
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        appBar: new AppBar(
          title: const Text('Dynamic Links Example'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: !_isCreatingLink
                        ? () {
                            _createDynamicLink(false);
                            final RenderBox box = context.findRenderObject();
                            Share.share(
                                _linkMessage ??
                                    'Hi This is a Remote Mesage from a different app',
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size);
                          }
                        : null,
                    child: const Text('Get Long Link'),
                  ),
                  new RaisedButton(
                    onPressed: !_isCreatingLink
                        ? () {
                            _createDynamicLink(true);
                            final RenderBox box = context.findRenderObject();
                          }
                        : null,
                    child: const Text('Get Short Link'),
                  ),
                ],
              ),
              new Text(
                _linkMessage ?? '',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DynamicLinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        appBar: new AppBar(
          title: const Text('Hello World DeepLink'),
        ),
        body: const Center(
          child: const Text('Hello, World!'),
        ),
      ),
    );
  }
}
