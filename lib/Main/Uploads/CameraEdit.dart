import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CameraEdit extends StatefulWidget {
  CameraEdit({this.url, this.type});

  final String url;
  final String type;

  CameraEditState createState() => CameraEditState();
}

class CameraEditState extends State<CameraEdit> with TickerProviderStateMixin {
  File imageFile;
  AppState state;
  ValueChanged<Color> onColorChanged;
  Color fontColor = new Color(0xff443a49);
  Color currentColor = new Color(0xff443a49);
  double fontSize = 16.0;
  String fontFamily;
  TextAlign textAlign = TextAlign.center;
  String qoute;
  FontStyle fontStyle;
  PageController controller = new PageController();
  List<Widget> imageFiltterd = [];
  bool isCrop = false,
      isQuote = false,
      isLocked = false,
      isWrite = false,
      isFont = false;

  bool isFilter = false;

  bool isPresetFilter = false;

  var iscustomFilter = false;

  changeColor(Color color) {
    setState(() {
      fontColor = color;
    });
  }

  bool textEditing = false;
  TextEditingController q_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.flip,
                color: isCrop ? Colors.lightBlueAccent : Colors.white70,
              ),
              onPressed: () {
                _flipImage();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.crop,
                color: isCrop ? Colors.lightBlueAccent : Colors.white70,
              ),
              onPressed: () {
                _cropImage();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.format_quote,
                color: isQuote ? Colors.lightBlueAccent : Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  isQuote = true;
                  isFilter = false;
                  isWrite = false;
                  isCrop = false;
                  isPresetFilter = false;
                  isFont = false;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.filter,
                color: isFilter ? Colors.lightBlueAccent : Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  isQuote = false;
                  isFilter = true;
                  isWrite = false;
                  isCrop = false;
                  isPresetFilter = false;
                  isFont = false;
                });
              },
            ),
            IconButton(
                icon: Icon(
              FontAwesomeIcons.pen,
              color: isWrite ? Colors.lightBlueAccent : Colors.white70,
            )),
            IconButton(
                icon: Icon(
              Icons.insert_emoticon,
              color: isCrop ? Colors.lightBlueAccent : Colors.white70,
            )),
          ],
        ),
        body: Stack(fit: StackFit.expand, children: <Widget>[
          new GestureDetector(
              onTap: () {
                if (isLocked) {
                  setState(() {
                    isLocked = true;
                  });
                  isLocked = false;
                } else {
                  setState(() {
                    isLocked = false;
                  });
                  isLocked = true;
                }
              },
              child: Center(
                  //Change to cutom load animation
                  /*
          *  NetworkImage(picture.pictureUrl),
          fit: BoxFit.cover,
            alignment: Alignment.center,
          )
           */

                  child: new Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: new PhotoView(
                    imageProvider: FileImage(imageFile),
                    minScale: PhotoViewScaleBoundary.contained,
                    maxScale: 4.0),
              ))),
          Align(
              alignment: Alignment.center,
              child: Container(
                  width: 300.0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isLocked = true;
                      });
                    },
                    child: TextField(
                      maxLines: 10,
                      enabled: isLocked,
                      maxLengthEnforced: true,
                      maxLength: 150,
                      keyboardType: TextInputType.multiline,
                      controller: q_controller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: textEditing,
                          fillColor: Colors.black12),
                      textAlign: textAlign,
                      style: TextStyle(
                          color: fontColor,
                          fontSize: fontSize,
                          fontFamily: fontFamily,
                          fontStyle: fontStyle),
                    ),
                  ))),
          /* PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: controller,
        //onPageChanged:,

    itemBuilder: (context,index){
    return new Center(//Change to cutom load animation
    /*
          *  NetworkImage(picture.pictureUrl),
          fit: BoxFit.cover,
            alignment: Alignment.center,
          )
           */
    child: new Padding(padding: const EdgeInsets.only(bottom:30.0),child:new PhotoView(
      imageProvider:  FileImage(new File(widget.url),),minScale: PhotoViewScaleBoundary.contained,
    maxScale:4.0),

    )

    );
    }
       ),*/
          Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: fontStyles(q_controller.text),
              )),
          Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: filters(),
              )),
          Align(
              alignment: Alignment.bottomCenter,
              child: isFilter
                  ? new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(FontAwesomeIcons.filter,
                                color: isPresetFilter
                                    ? Colors.lightBlueAccent
                                    : Colors.grey),
                            onPressed: () {
                              if (isPresetFilter) {
                                setState(() {
                                  isPresetFilter = true;
                                });
                                isPresetFilter = false;
                              } else {
                                setState(() {
                                  isPresetFilter = false;
                                });
                                isPresetFilter = true;
                              }
                            }),
                        IconButton(
                          icon: Icon(Icons.settings_input_composite,
                              color: iscustomFilter
                                  ? Colors.lightBlueAccent
                                  : Colors.grey),
                        )
                      ],
                    )
                  : isCrop
                      ? new Container(
                          margin: const EdgeInsets.symmetric(horizontal: 9.0),
                          child: new Row(
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  //controller: _textController,
                                  /* onChanged: (String txt) {
                     setState(() {
                       _isWriting = txt.length > 0;
                     });
                   },
                   onSubmitted: _submitMsg,*/
                                  decoration: InputDecoration(
                                    labelText: 'Enter Message',
                                    labelStyle: new TextStyle(
                                        fontFamily: 'Jua', color: Colors.white),
                                    border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(15.0),
                                        borderSide: new BorderSide(
                                            width: 6.0, color: Colors.white)),
                                  ),
                                  style: TextStyle(fontFamily: 'Jua'),
                                ),
                              ),
                              new Container(
                                  margin:
                                      new EdgeInsets.symmetric(horizontal: 3.0),
                                  child: Theme.of(context).platform ==
                                          TargetPlatform.iOS
                                      ? new CupertinoButton(
                                          child: new Text("Submit"),
                                          onPressed: () {})
                                      : new FloatingActionButton(
                                          child: new Icon(
                                            Icons.send,
                                          ),
                                          backgroundColor: Colors.purpleAccent,
                                          onPressed: () {},
                                        )),
                            ],
                          ),
                          decoration: Theme.of(context).platform ==
                                  TargetPlatform.iOS
                              ? new BoxDecoration(
                                  border: new Border(
                                      top: new BorderSide(color: Colors.brown)))
                              : null)
                      : isQuote
                          ? new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.format_color_text,
                                        color: fontColor),
                                    onPressed: () {
                                      fontColor = currentColor;
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Pick a color!'),
                                            content: SingleChildScrollView(
                                              child: ColorPicker(
                                                pickerColor: fontColor,
                                                onColorChanged: changeColor,
                                                colorPickerWidth: 1000.0,
                                                pickerAreaHeightPercent: 0.7,
                                              ),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Got it'),
                                                onPressed: () {
                                                  setState(() =>
                                                      currentColor = fontColor);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Slider(
                                          value: fontSize,
                                          min: 8.0,
                                          max: 60.0,
                                          divisions: 12,
                                          label: '${fontSize.round()}',
                                          onChanged: (double newValue) {
                                            setState(() {
                                              fontSize = newValue;
                                            });
                                          },
                                          onChangeStart: (double startValue) {
                                            print(
                                                'Started change at $startValue');
                                          },
                                        ),
                                        Text(
                                          fontSize.round().toString() + 'px',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: fontColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                  IconButton(
                                      icon: Icon(FontAwesomeIcons.font,
                                          color: isFont
                                              ? Colors.lightBlueAccent
                                              : Colors.grey),
                                      onPressed: () {
                                        if (isFont) {
                                          setState(() {
                                            isFont = true;
                                          });
                                          isFont = false;
                                        } else {
                                          setState(() {
                                            isFont = false;
                                          });
                                          isFont = true;
                                        }
                                      })
                                ])
                          : !isWrite
                              ? new Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 9.0),
                                  child: new Row(
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextField(
                                          //controller: _textController,
                                          /* onChanged: (String txt) {
                     setState(() {
                       _isWriting = txt.length > 0;
                     });
                   },
                   onSubmitted: _submitMsg,*/
                                          decoration: InputDecoration(
                                            labelText: 'Enter Message',
                                            labelStyle: new TextStyle(
                                                fontFamily: 'Jua',
                                                color: Colors.white),
                                            border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    width: 6.0,
                                                    color: Colors.white)),
                                          ),
                                          style: TextStyle(fontFamily: 'Jua'),
                                        ),
                                      ),
                                      new Container(
                                          margin: new EdgeInsets.symmetric(
                                              horizontal: 3.0),
                                          child: Theme.of(context).platform ==
                                                  TargetPlatform.iOS
                                              ? new CupertinoButton(
                                                  child: new Text("Submit"),
                                                  onPressed: () {})
                                              : new FloatingActionButton(
                                                  child: new Icon(
                                                    Icons.send,
                                                  ),
                                                  backgroundColor:
                                                      Colors.purpleAccent,
                                                  onPressed: () {},
                                                )),
                                    ],
                                  ),
                                  decoration: Theme.of(context).platform ==
                                          TargetPlatform.iOS
                                      ? new BoxDecoration(
                                          border: new Border(
                                              top: new BorderSide(
                                                  color: Colors.brown)))
                                      : null)
                              : new Container())
        ]));
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        ratioX: 1.0,
        ratioY: 1.0,
        toolbarTitle: 'Crop',
        toolbarColor: Colors.black);

    if (croppedFile != null) {
      imageFile = croppedFile;

      setState(() {
        state = AppState.cropped;
      });
    }
  }

  Widget fontStyles(String text) {
    List<String> fontFamilies = [
      'Actonica',
      'Acme',
      'Anton',
      'Audiowide',
      'Chela',
      'Chicle',
      'Engagement',
      'Exo',
      'Galada',
      'Gochi',
      'Inconsolata',
      'Indie_flower',
      'Jua',
      'Kaushan',
      'Knewave',
      'Lobster',
      'Monoton',
      'Pacifico',
      'Passion',
      'Pattaya',
      'Poor_Story',
      'PT_Sans'
    ];
    Widget tick = Icon(
      FontAwesomeIcons.checkCircle,
      color: Colors.green.withOpacity(0.8),
    );
    List<Widget> fonts = new List<Widget>();
    for (String s in fontFamilies) {
      fonts.add(new InkWell(
          onTap: () {
            setState(() {
              fontFamily = s;
            });
          },
          child: SizedBox(
              width: 100.0,
              height: 50.0,
              child: new Column(
                children: <Widget>[
                  new Text(
                    s,
                    style: TextStyle(fontFamily: s, color: Colors.white),
                  ),
                  new Card(
                      child: new Container(
                    height: 100.0,
                    width: 100.0,

                    // elevation: 10.0,
                    child: new Stack(fit: StackFit.expand, children: <Widget>[
                      new Image(
                          //placeholder: AssetImage('images/big_circleLoader.gif'),
                          image: new FileImage(
                            new File(imageFile.path),
                          ),
                          fit: BoxFit.fill),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: s == fontFamily ? tick : new Container(),
                      ),
                      new Center(
                          child: Text(
                        text,
                        style: TextStyle(fontFamily: s, color: Colors.white),
                      )),
                    ]),
                  ))
                ],
              ))));
    }
    return !isFont
        ? new Container()
        : Container(
            height: 150.0,
            child: ListView(
                // This next line does the trick.

                scrollDirection: Axis.horizontal,
                children: fonts));
  }

  Future<Null> _flipImage() async {
    img.Image image = img.decodeImage(imageFile.readAsBytesSync());
    img.Image flipImage = img.flip(image, 1);
    File flippedFile = new File(imageFile.path)
      ..writeAsBytesSync(img.encodePng(flipImage));
    if (flippedFile != null) {
      imageFile = flippedFile;

      setState(() {
        state = AppState.cropped;
      });
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = image;
    });
  }

  @override
  void initState() {
    imageFile = new File(widget.url);
    src = img.decodeImage(imageFile.readAsBytesSync());
    state = AppState.free;
    loadFilters();
  }

  @override
  void dispose() {}
  img.Image src;

  List<File> filefilters = List<File>();
  List<String> filtername = [
    'BBC',
    'Sepia',
    'Bright',
    'Convulsion',
    'Pixelate'
  ];

  loadFilters() {
    // img.Image src=img.decodeImage(imageFile.readAsBytesSync());

    img.Image gsimage = img.grayscale(src);
    img.Image spimage = img.sepia(src);
    img.Image bimage = img.brightness(src, 100);
    img.Image cimage = img.gaussianBlur(src, 2);
    img.Image pimage = img.pixelate(src, 3);

    List<img.Image> images = [gsimage, spimage, bimage, cimage, pimage];

    for (img.Image im in images) {
      print(im);
      filefilters
          .add(new File(imageFile.path)..writeAsBytesSync(img.encodePng(im)));
    }
  }

  Widget filters() {
    int index = 0;
    Widget tick = Icon(
      FontAwesomeIcons.checkCircle,
      color: Colors.green.withOpacity(0.8),
    );
    List<Widget> fonts = new List<Widget>();
    for (File f in filefilters) {
      fonts.add(new InkWell(
          onTap: () {
            setState(() {
              imageFile = f;
            });
          },
          child: SizedBox(
              width: 100.0,
              height: 50.0,
              child: new Column(
                children: <Widget>[
                  new Text(
                    filtername[index],
                    style: TextStyle(fontFamily: 'jua', color: Colors.white),
                  ),
                  new Card(
                      child: new Container(
                    height: 100.0,
                    width: 100.0,

                    // elevation: 10.0,
                    child: new Stack(fit: StackFit.expand, children: <Widget>[
                      new Image(
                          //placeholder: AssetImage('images/big_circleLoader.gif'),
                          image: new FileImage(f),
                          fit: BoxFit.fill),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: f == imageFile ? tick : new Container(),
                      ),
                    ]),
                  ))
                ],
              ))));
      index++;
    }
    return !isPresetFilter
        ? new Container()
        : Container(
            height: 150.0,
            child: ListView(
                // This next line does the trick.

                scrollDirection: Axis.horizontal,
                children: fonts));
  }
}

enum AppState {
  free,
  picked,
  cropped,
}
