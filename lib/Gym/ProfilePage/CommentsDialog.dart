import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twenty_four_hours/Gym/Models/Comments.dart';
import 'package:twenty_four_hours/Gym/Models/Picture.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:timeago/timeago.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/MainPage.dart';
/*class CommentsDialog extends StatefulWidget{
  final Picture picture;
  final Profile myProfile;
 CommentsDialog({this.picture,this.myProfile});
  Commentstate createState()=>Commentstate(picture:picture,myProfile: myProfile );
}
class Commentstate extends State<CommentsDialog> with TickerProviderStateMixin
{
  final Picture picture;
  final Profile myProfile;
  List<CommentPage>commentpage=new List<CommentPage>();
  var textstyle=TextStyle(fontFamily: 'Jua',color:Colors.black87);

  Commentstate({this.picture,this.myProfile});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body:Column(
      children: <Widget>[
        new Flexible(child: new ListView.builder(
    itemBuilder: (_,int index){commentpage[index];
      //return new Padding(padding: const EdgeInsets.all(16.0),child: commmentLog(picture.comments[index]));
    },
    itemCount:commentpage.length,
    reverse: true,
    padding: const EdgeInsets.all(5.0),
    )
        ),
        Divider(height: 1.0),
        new Container(
          child: _buildComposer(),
          decoration: new BoxDecoration(),
        )

      ],
    ));
  }
  Future _goToUser(BuildContext context,Profile p) async {
    Navigator.pop(context);
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new MainPage(profile: p);
        },
        fullscreenDialog: true
    ));
  }
  int cmts=0;
  bool like=false;
  TextEditingController _textEdit=new TextEditingController();
  bool _isWritting=false;


  Widget _buildComposer() {
    return new IconTheme(
      data: new IconThemeData(
        color: _nameToColor(myProfile.user.username),),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 9.0),
        child: new Row(
          children: <Widget>[
            new Flexible(child: TextField(
              controller: _textEdit,
              onChanged: (String txt){
                setState(() {
                  _isWritting=txt.length>0;
                });
              },
              decoration: new InputDecoration.collapsed(hintText: 'Enter comment',hintStyle: textstyle),
              onSubmitted: _submitComment,
            )),
            new Container(
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
            child:Theme.of(context).platform==TargetPlatform.iOS ?
              new CupertinoButton(
                child: new Icon(Icons.send),
              onPressed: _isWritting? ()=>_submitComment(_textEdit.text):null
              ):
                new IconButton(icon: Icon(Icons.send), onPressed: _isWritting? ()=>_submitComment(_textEdit.text):null
                )

            )
          ]
          ),
        decoration: Theme.of(context).platform==TargetPlatform.iOS ? new BoxDecoration(border: const Border(top: const BorderSide(color: Colors.green))):null,

              ),);

  }
  Color _nameToColor(String name) {

    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();

  }


  @override
  void initState() {
    print("OPENING: COMMENTSDIALOG");
    print(picture.comments);
    if(picture.comments!=null)
      {
        for(Comments c in  picture.comments)
          {
            print(c);
            commentpage.add(new CommentPage(
              picture: c,
              cmts: cmts,
              like: like,
              myProfile: myProfile,
              txt: c.commment,
              animatedController:  new AnimationController(vsync: this,duration: Duration(milliseconds: 800)),
              goToUser: 1==1?(){}:_goToUser(context, c.commenter),


            ));
          }
      }
  }

  @override
  void dispose() {
    for(CommentPage c in commentpage)
      {
        c.animatedController.dispose();
      }
      super.dispose();
  }


  void _submitComment(String txt) {
  _textEdit.clear();
  setState(() {
    _isWritting=false;
  });
  CommentPage newComment=new CommentPage(
      picture: new Comments(myProfile,txt,[new Profile()],),
      cmts: cmts,
      like: like,
      myProfile: myProfile,
      txt: txt,
      goToUser:1==1?(){}: _goToUser(context, myProfile),
      animatedController: new AnimationController(vsync: this,duration: Duration(milliseconds: 800)));
  setState(() {
    commentpage.insert(0, newComment);
    print(commentpage.length);
  });
  newComment.animatedController.forward();
  }

}
class CommentPage extends StatelessWidget
{
  final Comments picture;
  final VoidCallback goToUser;
  final Profile myProfile;
  final String txt;
  final int cmts;
  final bool like;
  var textstyle=TextStyle(fontFamily: 'Jua',color:Colors.black87);
  final AnimationController animatedController;

  CommentPage({this.picture,this.cmts,this.like,this.myProfile,this.txt,this.animatedController,this.goToUser});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new SizeTransition(sizeFactor:
        new CurvedAnimation(parent: animatedController, curve: Curves.bounceOut),
    axisAlignment: 0.0,
    child:new Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
      child:  new Text(txt,style: textstyle,),)
    /*new SizeTransition(sizeFactor:
    new CurvedAnimation(parent: animatedController, curve: Curves.bounceOut),
    axisAlignment: 0.0,
      child:new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: new CircleAvatar(backgroundImage: NetworkImage(myProfile.user.profile_pic_url),
              ),//**/
            ),
            new Expanded(child: new Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(myProfile.user.username,style: textstyle,),
              new Container(
                margin: const EdgeInsets.only(top: 6.0),
                child:  new Text(txt,style: textstyle,),
              )
            ],
            ))
          ],
        )//commmentLog(picture),
      )*/
    );
  }
  Widget commmentLog(Comments p) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new GestureDetector(
            onTap: () {
              goToUser;
            },
            child: new CircleAvatar(
              backgroundImage: NetworkImage(p.commenter.user.profile_pic_url),
            )
        ),
        new Padding(padding: const EdgeInsets.all(10.0),

            child: new Expanded(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(p.commenter.user.username, style: textstyle,),
                Text(p.commment, style: textstyle,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,),

                new Padding(padding: const EdgeInsets.all(10.0),
                    child: new Row(
                        children: <Widget>[
                          new IconButton(
                              icon: Icon(Icons.thumb_up), onPressed: null),
                          new Text(p.likedComment != null && like ? (cmts + 1)
                              .toString() : '0'),

                        ])),
                new Padding(padding: const EdgeInsets.all(10.0),
                    child: new Row(
                        children: <Widget>[
                          new IconButton(
                              icon: Icon(Icons.thumb_down), onPressed: null),
                          new Text(p.likedComment != null && like ? (cmts - 1)
                              .toString() : '0'),

                        ])),
                new Padding(padding: const EdgeInsets.all(10.0),

                  child: new Text('• ${p
                      .getDuration(DateTime.now())
                      .inHours}h ago' != null && like
                      ? (cmts - 1).toString()
                      : '0'),

                )
              ],
            )))
      ],
    );
  }

}*/
import 'package:flutter/foundation.dart';

final ThemeData iOSTheme = new ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[400],
  primaryColorBrightness: Brightness.dark,
);

final ThemeData androidTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.green,
);

const String defaultUserName = "John Doe";

class CommentsDialog extends StatefulWidget {
  final Picture picture;
  final Profile myProfile;

  CommentsDialog({this.picture, this.myProfile});

  Commentstate createState() =>
      Commentstate(picture: picture, myProfile: myProfile);
}

class Commentstate extends State<CommentsDialog> with TickerProviderStateMixin {
  final Picture picture;
  final Profile myProfile;

  var textstyle = TextStyle(fontFamily: 'Jua', color: Colors.black87);

  Commentstate({this.picture, this.myProfile});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      theme:
          defaultTargetPlatform == TargetPlatform.iOS ? iOSTheme : androidTheme,
      home: new Chat(
        myProfile: myProfile,
        picture: picture,
      ),
    );
  }
}

class Chat extends StatefulWidget {
  final Picture picture;
  final Profile myProfile;

  Chat({this.picture, this.myProfile});

  @override
  State createState() => new ChatWindow(picture: picture, myProfile: myProfile);
}

class ChatWindow extends State<Chat> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;
  final Picture picture;
  final Profile myProfile;

  ChatWindow({this.picture, this.myProfile});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        // leading: IconButton(onPressed:(){Navigator.p;},icon: Icon(Icons.arrow_back,color: Colors.white,),),
        title: new Text(
          'Comments',
          style: new TextStyle(color: Colors.white, fontFamily: 'Jua'),
        ),
        backgroundColor: _nameToColor(myProfile.user.username),
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
          reverse: true,
          padding: new EdgeInsets.all(6.0),
        )),
        new Divider(height: 1.0),
        new Container(
          child: _buildComposer(),
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
        ),
      ]),
    );
  }

  var textstyle = TextStyle(fontFamily: 'Jua', color: Colors.black87);

  Widget _buildComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onChanged: (String txt) {
                    setState(() {
                      _isWriting = txt.length > 0;
                    });
                  },
                  onSubmitted: _submitMsg,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Enter comment", hintStyle: textstyle),
                ),
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                          child: new Text("Submit"),
                          onPressed: _isWriting
                              ? () => _submitMsg(_textController.text)
                              : null)
                      : new IconButton(
                          icon: new Icon(Icons.send),
                          onPressed: _isWriting
                              ? () => _submitMsg(_textController.text)
                              : null,
                        )),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border: new Border(top: new BorderSide(color: Colors.brown)))
              : null),
    );
  }

  void initChat(Msg msg) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    setState(() {
      _messages.add(msg);
      // _messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  void _submitMsg(String txt) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });

    Msg msg = new Msg(
      txt: txt,
      myProfile: myProfile,
      picture: new Comments(
        myProfile,
        txt,
        [new Profile()],
      ),
      name: myProfile.user.username,
      animationController: new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 800)),
    );
    setState(() {
      List<List<String>> comments = new List<List<String>>();
      comments.add(new List<String>());

      _messages.insert(0, msg);
      picture.comments.add(new Comments(myProfile, txt, [], comments));
    });
    msg.animationController.forward();
  }

  @override
  void initState() {
    print("OPENING: COMMENTSDIALOG");
    print(picture.comments);
    if (picture.comments != null) {
      for (Comments c in picture.comments) {
        print(c);
        _messages.add(new Msg(
            picture: c,
            cmts: _messages.length,
            like: false,
            name: c.commenter.user.username,
            myProfile: c.commenter,
            txt: c.commment,
            animationController: new AnimationController(
                vsync: this, duration: Duration(milliseconds: 800)),
            goToUser: () {} // 1==1?(){}:_goToUser(context, c.commenter),

            ));
        for (Msg m in _messages) m.animationController.forward();
        //initChat(msg);
      }
    }
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}

class Msg extends StatelessWidget {
  final Comments picture;
  final VoidCallback goToUser;
  final Profile myProfile;
  final String txt;
  final int cmts;
  final bool like;
  final String name;
  final String dur;

  Msg(
      {this.txt,
      this.animationController,
      this.name,
      this.dur,
      this.myProfile,
      this.picture,
      this.cmts,
      this.like = false,
      this.goToUser});

  final AnimationController animationController;
  var textstyle = TextStyle(fontFamily: 'Jua', color: Colors.black87);

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  TimeAgo ta = new TimeAgo();

  @override
  Widget build(BuildContext ctx) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: new Column(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(right: 18.0),
                    child: new CircleAvatar(
                      backgroundImage:
                          NetworkImage(myProfile.user.profile_pic_url),
                    ),
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                            '$name • ${ta.format(DateTime.now().subtract(
                            new Duration(seconds: picture.getDuration(
                                DateTime.now()))))}',
                            style: textstyle),
                        new Container(
                          margin: const EdgeInsets.only(top: 6.0),
                          child: new Text(txt),
                        ),
                      ],
                    ),
                  ),
                  new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Row(children: <Widget>[
                        new IconButton(
                            icon: Icon(Icons.thumb_up), onPressed: null),
                        new Text(picture.likedComment != null && like
                            ? (cmts + 1).toString()
                            : '0'),
                      ])),
                  new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Row(children: <Widget>[
                        new IconButton(
                            icon: Icon(Icons.thumb_down), onPressed: null),
                        new Text(picture.likedComment != null && like
                            ? (cmts - 1).toString()
                            : '0'),
                      ])),
                ],
              ),
            ),
            /* new SizedBox.fromSize(
    //  height: 20.0,width: 20.0,
   size: Size(30.0,30.0),
    child: new Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
    new Container(
    child: new CircleAvatar(backgroundImage: NetworkImage(myProfile.user.profile_pic_url),),
    ),
    new Expanded(
    child: new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    new Text('$name • ${DateTime.now().difference(DateTime.now()).inHours}h', style: textstyle),
    new Container(
    margin: const EdgeInsets.only(top: 6.0),
    child: new Text(txt),
    ),
    ],
    ),
    ),
    new Padding(padding: const EdgeInsets.all(10.0),
    child: new Row(
    children: <Widget>[
    new IconButton(
    icon: Icon(Icons.thumb_up), onPressed: null),
    new Text(picture.likedComment != null && like ? (cmts + 1)
        .toString() : '0'),

    ])),
   // new Padding(padding: const EdgeInsets.all(10.0),
    //child:
    new Row(
    children: <Widget>[
    new IconButton(
    icon: Icon(Icons.thumb_down), onPressed: null),
    new Text(picture.likedComment != null && like ? (cmts - 1)
        .toString() : '0'),

    ]),//),
    ],
    ),
    ),*/
          ],
        ));
  }
}
