import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart';
import 'package:twenty_four_hours/Gym/Models/Comments.dart';
import 'package:twenty_four_hours/Gym/Models/Gallery.dart';
import 'package:twenty_four_hours/Gym/Models/Picture.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/CommentsDialog.dart';

class FullImageDisplay extends StatefulWidget {
  final Picture image;
  final Profile myProfile;
  final Gallery gallery;
  final Profile profile;

  FullImageDisplay({this.image, this.myProfile, this.gallery, this.profile});

  FullImageDisplayState createState() => FullImageDisplayState(
      image: image, myProfile: myProfile, gallery: gallery, profile: profile);
}

class FullImageDisplayState extends State<FullImageDisplay>
    with TickerProviderStateMixin {
  final Picture image;
  final Profile myProfile;
  final Gallery gallery;
  final Profile profile;

  bool ready = false;
  bool showPerformanceOverlay = false;
  static final textStyle =
      new TextStyle(fontFamily: 'Jua', color: Colors.white);
  bool tapped = false;

  Duration _dur = new Duration(milliseconds: 500);

  FullImageDisplayState(
      {this.myProfile, this.image, this.gallery, this.profile});

  PageController controller;
  AnimationController aniimController;
  String title = '';
  int likes = 0;
  int comment = 0;
  Picture img = new Picture();
  Widget BottomSheetItems = new Container();

  @override
  Widget build(BuildContext context) {
    // print(gallery.pictures);

    // TODO: implement build
    return DisplayImage();
  }

  @override
  void initState() {
    _retrieveDynamicLink();

    print("~~${profile.user.username}");

    aniimController = new AnimationController(vsync: this, duration: _dur);
    controller =
        new PageController(initialPage: gallery.pictures.indexOf(image));
    setState(() {
      title = gallery.pictures[controller.initialPage].title;
      likes = gallery.pictures[controller.initialPage].Likes;
      comment = gallery.pictures[controller.initialPage].picComments;
      img = gallery.pictures[controller.initialPage];
      BottomSheetItems = _showData(title, likes, comment, img);
    });

    print("Current pg: ");
    //reorderList();
    //   print("+++${gallery.pictures.forEach((p){p.title;})}");
  }

  reorderList() {
    int i = 0, j = 0;
    List<Picture> pics = new List<Picture>();
    for (Picture p in gallery.pictures) {
      print(i++);
      if (p.pictureUrl == image.pictureUrl) {
        pics.add(p);
        print(pics);
        for (Picture p in gallery.pictures) {
          if (gallery.pictures.indexOf(p) > gallery.pictures.indexOf(pics[0])) {
            pics.add(p);
            print(pics);
          }
        }
      }
    }
    for (Picture p in gallery.pictures) {
      print(j++);
      if (!pics.contains(p.pictureUrl) && (p.pictureUrl != image.pictureUrl)) {
        pics.add(p);
        print(pics);
      }
    }
    gallery.pictures.clear();
    gallery.pictures.addAll(pics);
  }

  @override
  void dispose() {
    controller.dispose();
  }

  Widget DisplayImage() {
    return GestureDetector(
        onTap: () {
          // displayContainers();
          if (tapped) {
            setState(() {
              tapped = true;
            });
            print("TAPPED***: $tapped");
            tapped = false;
          } else {
            setState(() {
              tapped = false;
            });
            print("TAPPED***: $tapped");
            tapped = true;
          }
        },
        onDoubleTap: () {
          setState(() {
            tapped = false;
          });
          print("Double TAPPED***: $tapped");
        },
        child: Stack(fit: StackFit.expand, children: <Widget>[
          PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: controller,
            onPageChanged: (page) {
              setState(() {
                title = gallery.pictures[page].title;
                likes = gallery.pictures[page].Likes;
                comment = gallery.pictures[page].picComments;
                img = gallery.pictures[page];
                BottomSheetItems = _showData(title, likes, comment, img);
              });
            },
            itemBuilder: (context, index) {
              return new Center(
                //Change to cutom load animation
                /*
          *  NetworkImage(picture.pictureUrl),
          fit: BoxFit.cover,
            alignment: Alignment.center,
          )
           */
                child: FadeInImage.assetNetwork(
                  placeholder: 'images/ajax-loader.gif',
                  image: gallery.pictures[index].pictureUrl,
                  fit: BoxFit.cover,
                ),
              );
            },
            itemCount: gallery.pictures.length,
          ),
          tapped
              ? new Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: Colors.transparent,
                  appBar: new AppBar(
                    backgroundColor: Colors.transparent,
                    title: Text(
                      title,
                      style: textStyle,
                    ),
                  ),
                  body: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black87, Colors.black26])),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[displayContainers()],
                      )))
              : new Container(),
        ]));
  }

  void choice() {}

  bool isPictureLiked(Picture p) {
    if (p.likedBy != null) if (p.likedBy.contains(profile)) return true;

    return false;
  }

  _changeLike(Picture p) {
    print("Liked Clicked**$liked");
    if (!liked) {
      p.likedBy.add(profile);
      liked = true;
      //updateDatabase;
    } else {
      p.likedBy.remove(profile);
      liked = false;
    }
    print(p.likedBy);
    setState(() {
      liked = isPictureLiked(p);

      if (liked) {
        showInSnackBar('Liked ${profile.user.username}');
      }
    });
  }

  bool liked = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  String _linkMessage;
  bool _isCreatingLink = false;

  @override
  BuildContext get context => super.context;

  String getLikes(int likes, Picture image) {
    print("Getting likes");

    print("MYPROFILE: ${myProfile}");
    print("Image: yh${image.myFriends(myProfile.friends.friends)}");
    String plus1 = ''; //
    String plus2 = '';
    String plus3 = '';

    print("ASD: ${image.myFriends(myProfile.friends.friends)}");
    if (image.myFriends(myProfile.friends.friends).isNotEmpty) {
      if (image.myFriends(myProfile.friends.friends).length >= 3) {
        plus3 = '${image
            .myFriends(myProfile.friends.friends)
            .last
            .user
            .username}, ${image.myFriends(myProfile.friends.friends)[image
            .myFriends(myProfile.friends.friends)
            .length - 1]}, ${image.myFriends(myProfile.friends.friends)[image
            .myFriends(myProfile.friends.friends)
            .length - 2]} And ${likes - 3} others';
        if (liked)
          return 'You $plus3 Liked this';
        else
          return '$plus3 Liked this';
      } else if (image.myFriends(myProfile.friends.friends).length >= 2) {
        plus2 = '${image
            .myFriends(myProfile.friends.friends)
            .last
            .user
            .username}, ${image.myFriends(myProfile.friends.friends)[image
            .myFriends(myProfile.friends.friends)
            .length - 1]} And ${likes - 2} others';

        if (liked)
          return 'You $plus2 Liked this';
        else
          return '$plus2 Liked this';
      } else {
        plus1 = '${image
            .myFriends(myProfile.friends.friends)
            .last
            .user
            .username} And ${likes - 1} other';

        if (liked)
          return 'You $plus1 Liked this';
        else
          return '$plus1 Liked this';
      }
    } else {
      if (liked)
        return 'You and ${getVal(likes)} other Liked this';
      else
        return '${getVal(likes)} Likes';
    }
  }

  int dex;
  var textstyle = TextStyle(fontFamily: 'Jua', color: Colors.black87);
  var textstyle2 = TextStyle(fontFamily: 'Jua', color: Colors.white70);

  String getVal(int val) {
    return new NumberFormat.compact().format(val);
  }

  Widget _showData(String caption, int likes, int comments, Picture image) {
    bool like = true;

    print("-----ADSDFGHJ----$image");
    print('LIKE::$like');
    likes = image.likedBy != null ? image.likedBy.length : 0;
    print("Liked by: $likes");
    var HeadingStyle = TextStyle(
        fontFamily: 'Engagement', color: Colors.white, fontSize: 22.0);
    var subHeadingStyle =
        TextStyle(fontFamily: 'Jua', color: Colors.white70, fontSize: 12.0);

    Widget likeInfoWidget = Padding(
        padding: EdgeInsets.all(8.0),
        child: FlatButton(
            onPressed: null,
            child: Text(
              likes >= 1 ? getLikes(likes, image) : 'No Likes Yet',
              style: subHeadingStyle,
            )));

    var captionWidget = Row(children: <Widget>[
      //  new Transform.rotate(angle: 0.2,child:new Icon(Icons.format_quote,size: 22.0,color: Colors.white,)),
      FlatButton(
          onPressed: null,
          child: Text('•  ' + caption + '  •', style: HeadingStyle)),
      Text(
        '- ' + profile.user.username,
        style: subHeadingStyle,
        overflow: TextOverflow.fade,
        maxLines: 6,
      )
    ]);
    var commentsInfoWidget = FlatButton(
      child: image.comments != null
          ? image.comments.length != 0
              ? _showComments(image.comments.length, image)
              : Text(
                  'No Comments yet',
                  style: subHeadingStyle,
                )
          : Text(
              'No Comments yet',
              style: subHeadingStyle,
            ),
      onPressed: () {
        _goToUser(context, image);
      },
    );
    var toolsWidget = Padding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new IconButton(
                    onPressed: () {
                      _changeLike(image);
                    },
                    icon: Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ))),
            new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new IconButton(
                    icon: Icon(
                      Icons.format_quote,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _goToUser(context, image);
                    })),
            new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _getShare(context, image);
                    })),
            new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new IconButton(
                    icon: Icon(
                      Icons.library_add,
                      color: Colors.white,
                    ),
                    onPressed: null)),
          ],
        ),
        padding: EdgeInsets.only(bottom: 5.0));

    return Column(children: [toolsWidget, likeInfoWidget, commentsInfoWidget]);
  }

  Widget _showProfilePicture(Picture image) {
    return FadeInImage.assetNetwork(
      placeholder: image.pictureUrl,
      image: image.pictureUrl,
      fit: BoxFit.contain,
    );
  }

  TimeAgo ta = new TimeAgo();

  Widget _showComments(int cmt, Picture img) {
    return new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /* new Container(
    margin: const EdgeInsets.only(right: 18.0),
    child: new CircleAvatar(backgroundImage: NetworkImage(picture.commenter.user.profile_pic_url),),
    ),*/
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: cmt >= 2
                  ? <Widget>[
                      new Padding(
                          padding: const EdgeInsets.all(3.0),
                          child:
                              new Text('$cmt comment(s)', style: textstyle2)),
                      new Text(
                          '${img.comments[img.comments.length - 1].commenter.user
                    .username} • ${img.comments[img.comments.length - 1]
                    .commment}',
                          style: textstyle2),
                      /*new Container(
                  margin: const EdgeInsets.only(top: 6.0),
                  child: new Text(comment,style: textstyle2,),
                ),*/
                      new Text(
                          '${img.comments[img.comments.length - 2].commenter.user
                    .username} • ${img.comments[img.comments.length - 2]
                    .commment}',
                          style: textstyle2),
                      new Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            cmt > 1
                                ? 'see all $cmt Comments on this picture'
                                : 'Add a Comment',
                            style: textstyle2),
                      )
                    ]
                  : <Widget>[
                      new Padding(
                          padding: const EdgeInsets.all(3.0),
                          child:
                              new Text('$cmt comment(s)', style: textstyle2)),
                      new Text(
                          '${img.comments[0].commenter.user.username} • ${img
                    .comments[0].commment}',
                          style: textstyle2),
                      new Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            cmt > 1
                                ? 'see all $cmt Comments on this picture'
                                : 'Add a Comment',
                            style: textstyle2),
                      )
                    ],
            ),
          ),
        ]);
  }

  Widget displayContainers() {
    return BottomSheetItems;
  }

  /******************************/

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
      link: Uri.parse('https://24hours.page.link'),
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

/*******************************/

  Future _goToUser(BuildContext context, Picture p) async {
    print(myProfile.user.username);
    //Navigator.pop(context);
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CommentsDialog(
            myProfile: myProfile,
            picture: p,
          );
        },
        fullscreenDialog: false));
  }

  Future<Null> _getShare(context, Picture image) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: new Icon(Icons.close)),
            content: new Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new GestureDetector(
                    onTap: !_isCreatingLink
                        ? () {
                            Navigator.pop(context);
                            _createDynamicLink(false);
                            final RenderBox box = context.findRenderObject();
                          }
                        : null,
                    child: new Column(children: <Widget>[
                      new CircleAvatar(
                          radius: 60.0,
                          backgroundImage:
                              NetworkImage(profile.user.profile_pic_url)),
                      Text('Send Them Here(Recommended)', style: textstyle),
                    ]),
                  ),
                  new GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Share.share(
                        "Hey, Check out this picture\n" + image.pictureUrl ??
                            'Hi This is a Remote Mesage from a different app',
                      );
                    },
                    child: new Column(children: <Widget>[
                      new CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(image.pictureUrl)),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Share.share("Hey, Check out this picture\n" +
                                  image.pictureUrl ??
                              'Hi This is a Remote Mesage from a different app');
                        },
                        child: Text('Image Link',
                            style: TextStyle(color: Colors.blue)),
                      ),
                      FlatButton(
                        onPressed: !_isCreatingLink
                            ? () {
                                Navigator.pop(context);
                                _createDynamicLink(
                                    false); //change to true later    final RenderBox box = context.findRenderObject();
                              }
                            : null,
                        child: Text('Send Profile Link',
                            style: TextStyle(color: Colors.blue)),
                      )
                    ]),
                  ),
                ]),
            actions: <Widget>[],
          );
        });
  }
/*************************************/

}
