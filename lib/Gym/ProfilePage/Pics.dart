import 'dart:async';
import 'dart:ui' as deco;

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart';
import 'package:twenty_four_hours/Gym/Models/Comments.dart';
import 'package:twenty_four_hours/Gym/Models/Picture.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:simple_coverflow/simple_coverflow.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/CommentsDialog.dart';
import 'package:twenty_four_hours/Widget_Assets/Full_ImageDisplay.dart';
import 'package:twenty_four_hours/Gym/Models/Gallery.dart';

class PicsPage extends StatelessWidget {
  final Profile profile;
  final Profile myProfile;

  PicsPage({this.profile, this.myProfile});

  @override
  Widget build(BuildContext context) {
    return Pics(profile: profile, myProfile: myProfile);
  }
}

class Pics extends StatefulWidget {
  final Profile profile;
  final Profile myProfile;
  final String title;

  Pics({Key key, this.title, this.profile, this.myProfile}) : super(key: key);

  PicsState createState() =>
      new PicsState(profile: profile, myProfile: myProfile);
}

class PicsState extends State<Pics> {
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

  final Profile profile;
  final Profile myProfile;

  PicsState({this.profile, this.myProfile});

  bool selected = false;
  List<Picture> pics = new List<Picture>();
  List<Widget> data = [
    new Card(
      color: Colors.red,
    ),
    new Card(
      color: Colors.teal,
    ),
    new Card(
      color: Colors.pink,
    )
  ];
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

  @override
  void initState() {
    super.initState();
    _retrieveDynamicLink();

    //pics=profile.gallery.pictures;
    //pics.add(new Picture(profile.user.profile_pic_url, 'My Profile Picture', 'LOve This ☺'));
    pics.addAll(profile.gallery.pictures);
    print(pics[0].pictureUrl);
    data = _createContent();
  }

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

  String getLikes(int likes, Picture image) {
    print("Getting likes");

    print("MYPROFILE: ${myProfile.friends.friends.last.user.username}");
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

  Widget widgetBuilder(BuildContext context, int index) {
    print(picIndex);
    dex = index;
    if (pics.length == 0) {
      return Center(
          child: Text(
        'No Pictures',
        style: TextStyle(fontSize: 40.0, color: Colors.black54),
      ));
    } else {
      return data[index % pics.length];
    }
  }

  int picIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: Build HERE
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: _nameToColor(profile.user.username),
        title: new Text(
          '${profile.user.username}\'s Gallary',
          style: new TextStyle(
            color: Colors.white,
            fontFamily: 'Jua',
          ),
        ),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              _changeToGrid();
            },
            icon: Icon(Icons.grid_on,
                color: selected ? Colors.black38 : Colors.lightBlue),
          ),
          new IconButton(
            onPressed: () {
              _changeToCarosel();
            },
            icon: Icon(Icons.view_carousel,
                color: selected ? Colors.lightBlue : Colors.black38),
          ),
        ],
      ),
      body: selected ? _Carousel() : _GridView(),
    );
  }

  List<Widget> _createContent() {
    List<Widget> children = [];
    for (int i = 0; i < pics.length; i++) {
      print(pics.length);
      children.add(
        new Card(
            color: Colors.black26,
            key: new Key('PicKey$i'),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _showProfilePicture(pics[i]),
                  _showData(pics[i].title, pics[i].Likes, pics[i].picComments,
                      pics[i])
                ])),
      );
    }
    return children;
  }

  Widget _showData(String caption, int likes, int comments, Picture image) {
    bool like = true;

    print("-----------$image");
    print('LIKE::$like');
    likes = image.likedBy != null ? image.likedBy.length : 0;
    print("Liked by: $likes");
    var HeadingStyle = TextStyle(
        fontFamily: 'Engagement', color: Colors.white, fontSize: 22.0);
    var subHeadingStyle =
        TextStyle(fontFamily: 'Jua', color: Colors.white70, fontSize: 12.0);

    var likeInfoWidget = Padding(
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
              ? _showComments(
                  image.comments[0].commenter.user.username,
                  image.comments[0].commment,
                  image.comments[0],
                  image.comments.length)
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
        padding: EdgeInsets.only(bottom: 14.0));

    return Column(children: [
      toolsWidget,
      captionWidget,
      likeInfoWidget,
      commentsInfoWidget
    ]);
  }

  Widget _showProfilePicture(Picture image) {
    return GestureDetector(
        onTap: () {
          launchFullScreen(context, image);
        },
        child: FadeInImage.assetNetwork(
          placeholder: image.pictureUrl,
          image: image.pictureUrl,
          fit: BoxFit.contain,
        ));
  }

  TimeAgo ta = new TimeAgo();

  Widget _showComments(String name, String comment, Comments picture, int cmt) {
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
              children: <Widget>[
                new Text(
                    '$name • ${ta.format(DateTime.now().subtract(
                    new Duration(
                        seconds: picture.getDuration(DateTime.now()))))}',
                    style: textstyle2),
                new Container(
                  margin: const EdgeInsets.only(top: 6.0),
                  child: new Text(
                    comment,
                    style: textstyle2,
                  ),
                ),
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

  Widget _GridView() {
    return new GridView.count(
      padding: const EdgeInsets.only(top: 5.0),
      crossAxisCount: 3,
      children: new List.generate(

          // profile.gallery.pictures.length
          pics.length, (index) {
        return new Padding(
            padding: const EdgeInsets.all(2.0),
            child: ImageHolder(
                myProfile: myProfile,
                profile: profile,
                picture: pics[index],
                gallery: new Gallery(pics)));
      }),
    );
  }

  Widget _Carousel() {
    //return  new ImageCard(profile: profile,image: pics[0]);

    return Stack(fit: StackFit.expand, children: <Widget>[
      genrateBluredImage(pics[picIndex].pictureUrl),
      CoverFlow(
        itemBuilder: widgetBuilder,
      )
    ]);

    /*return new ListView(padding:const EdgeInsets.all(10.0),scrollDirection: Axis.horizontal,
      children: new List.generate(

        // profile.gallery.pictures.length
          pics.length , (index){
        return ImageCard(profile: profile,image: pics[0]);/* new Container(child: new Card(child: FadeInImage.assetNetwork(
        placeholder: 'big_CircleLoader.gif',
          image: pics[index].pictureUrl,
          fit: BoxFit.contain,)

        ));*/// ImageCard(profile: profile,image: pics[0]);
      }),);*/
  }

  Widget genrateBluredImage(String img) {
    return new DecoratedBox(
      decoration: new BoxDecoration(
        image: new DecorationImage(
            image: new NetworkImage(img),
            fit: BoxFit.none,
            repeat: ImageRepeat.repeat),
      ),
      //I blured the parent conainer to blur background image, you can get rid of this part
      child: new BackdropFilter(
        filter: deco.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: new Container(
          //you can change opacity with color here(I used black) for background.
          decoration: new BoxDecoration(color: Colors.black.withOpacity(0.5)),
        ),
      ),
    );
  }

  String getVal(int val) {
    return new NumberFormat.compact().format(val);
  }

  _changeToGrid() {
    setState(() {
      dex = 0;
      selected = false;
      print(selected);
    });
  }

  _changeToCarosel() {
    setState(() {
      selected = true;
      print("Seleted: $selected");
    });
  }

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  Future launchFullScreen(BuildContext context, Picture p) async {
    //Navigator.pop(context);
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          print("~${myProfile.user.username}");
          return new FullImageDisplay(
            myProfile: myProfile,
            image: p,
            gallery: new Gallery(pics),
            profile: profile,
          );
        },
        fullscreenDialog: false));
  }

  Future _goToUser(BuildContext context, Picture p) async {
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
}

class ImageHolder extends StatelessWidget {
  final double height;
  final double width;
  final Profile profile;
  final Picture picture;
  final Gallery gallery;
  final Profile myProfile;

  ImageHolder(
      {this.height = 200.0,
      this.picture,
      this.width = 180.0,
      this.profile,
      this.gallery,
      this.myProfile});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        launchFullScreen(context, picture, gallery);
      },
      child: new AnimatedContainer(
        duration: const Duration(
          milliseconds: 2000,
        ),
        height: height,
        width: width,
        decoration: const BoxDecoration(color: Colors.black26),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          overflow: Overflow.clip,
          children: <Widget>[
            Center(child: CircularProgressIndicator()),
            new Image(
              image: NetworkImage(picture.pictureUrl),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            )
          ],
        ),
      ),
    );
    // TODO: implement build
  }

  Future launchFullScreen(
      BuildContext context, Picture p, Gallery gallery) async {
    //Navigator.pop(context);
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new FullImageDisplay(
            myProfile: myProfile,
            image: p,
            gallery: gallery,
            profile: profile,
          );
        },
        fullscreenDialog: false));
  }
}

class ImageCard extends StatelessWidget {
  final double height;
  final double width;
  final Profile profile;
  final Picture image;
  final bool liked;
  final Function onProfileClicked;
  final Function onLikedInfoClicked;
  final Function onCommentsInfoClicked;

  ImageCard(
      {this.height = 200.0,
      this.onLikedInfoClicked,
      this.onCommentsInfoClicked,
      this.onProfileClicked,
      this.liked = false,
      this.width = 180.0,
      this.profile,
      this.image});

  @override
  Widget build(BuildContext context) {
    print("${image}");
    /*return Card(child: Image(image:NetworkImage(
      image.pictureUrl
    )
    );*/
    return Card(child: _info());
  }

  String getVal(int val) {
    return new NumberFormat.compact().format(val);
  }

  Widget _getCardContents() {
    print("HERE: ${image.picComments}");
    var contents = [
      Expanded(child: _showProfilePicture(image)),
      _showData(image.title, image.Likes, image.picComments),
    ];
    var children = _wrapInScrimAndExpand(Column(children: contents));

    return Column(children: children);
  }

  List<Widget> _wrapInScrimAndExpand(Widget child) {
    child = Container(
        foregroundDecoration:
            BoxDecoration(color: Color.fromARGB(150, 30, 30, 30)),
        child: child);

    child = Expanded(child: Row(children: [Expanded(child: child)]));

    return [child];
  }

  Widget _showProfilePicture(Picture image) {
    return FadeInImage.assetNetwork(
      placeholder: 'big_CircleLoader.gif',
      image: image.pictureUrl,
      fit: BoxFit.fill,
    );
  }

  Widget _info() {
    //print("HERE: ${image.picComments}");
    var contents = [
      _showProfilePicture(image),
      _showData(image.title, image.Likes, image.picComments),
    ];
    //var children = _wrapInScrimAndExpand(Column(children: contents));

    // return Column(children: children);
    return _showProfilePicture(image);
  }

  Widget _showData(String caption, int likes, int comments) {
    print('w355r765:$caption');
    var HeadingStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Jua',
        color: Colors.black54,
        fontSize: 14.0);
    var subHeadingStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Jua',
        color: Colors.black54,
        fontSize: 12.0);

    var likeInfoWidget = Padding(
        padding: EdgeInsets.all(8.0),
        child: FlatButton(
            onPressed: onLikedInfoClicked,
            child: Text(
              likes >= 1 ? getLikes(likes) : 'No Likes Yet',
              style: HeadingStyle,
            )));

    var captionWidget = Row(children: <Widget>[
      FlatButton(
          onPressed: onProfileClicked,
          child: Text(profile.user.username, style: HeadingStyle)),
      Text(
        caption,
        style: subHeadingStyle,
        overflow: TextOverflow.fade,
        maxLines: 6,
      )
    ]);
    var commentsInfoWidget = FlatButton(
      child: Text('see all $comments Comments on this picture'),
      onPressed: onCommentsInfoClicked,
    );
    var toolsWidget = Padding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new IconButton(
                    icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
                    onPressed: null)),
            new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new IconButton(
                    icon: Icon(Icons.format_quote), onPressed: null)),
            new Padding(
                padding: const EdgeInsets.all(5.0),
                child:
                    new IconButton(icon: Icon(Icons.share), onPressed: null)),
            new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new IconButton(
                    icon: Icon(Icons.library_add), onPressed: null)),
          ],
        ),
        padding: EdgeInsets.only(bottom: 16.0));

    return Column(children: [
      toolsWidget,
      captionWidget,
    ]); //likeInfoWidget,commentsInfoWidget]);
  }

  String getLikes(int likes) {
    String plus1 = '${image
        .myFriends(profile.friends.friends)
        .last
        .user
        .username} And ${likes - 1} others';
    String plus2;
    String plus3;
    if (image.myFriends(profile.friends.friends).isNotEmpty) {
      if (image.myFriends(profile.friends.friends).length >= 3) {
        plus3 = '${image
            .myFriends(profile.friends.friends)
            .last
            .user
            .username}, ${image.myFriends(profile.friends.friends)[image
            .myFriends(profile.friends.friends)
            .length - 1]}, ${image.myFriends(profile.friends.friends)[image
            .myFriends(profile.friends.friends)
            .length - 2]} And ${likes - 3} others';
        if (liked)
          return 'You $plus3 Liked this';
        else
          return '$plus3 Liked this';
      } else if (image.myFriends(profile.friends.friends).length >= 2) {
        plus2 = '${image
            .myFriends(profile.friends.friends)
            .last
            .user
            .username}, ${image.myFriends(profile.friends.friends)[image
            .myFriends(profile.friends.friends)
            .length - 1]} And ${likes - 2} others';

        if (liked)
          return 'You $plus2 Liked this';
        else
          return '$plus2 Liked this';
      } else {
        if (liked)
          return 'You $plus1 Liked this';
        else
          return '$plus1 Liked this';
      }
    } else {
      if (liked)
        return 'You and ${getVal(likes)} Liked this';
      else
        return '${getVal(likes)} Likes';
    }
  }
}
