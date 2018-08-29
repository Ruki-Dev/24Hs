import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lamp/lamp.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Main/Uploads/CameraEdit.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lamp/lamp.dart';
import 'package:image/image.dart' as img;

/// two types of camera campture [CameraPlugin] and [ImagePicker]
/// [CameraPlugin]
/// ADVANTAGES +++++
/// Design own ui,
/// embedded in 24hours
/// Add Later fetures e.g filters
/// switch from video to camer instantly
/// DISADVANTAGES ----
/// Poor front camera
/// presistant video bug
/// capture is flipped,
/// no flash
///[ImagePicker]
///ADVANTAGES +++++
///Utilizes the normal camera
///Speed
///easy to use
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;

    case CameraLensDirection.front:
      return Icons.camera_front;

    case CameraLensDirection.external:
      return Icons.camera;
  }

  throw new ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>

    print('Error: $code\nError Message: $message');

class CameraUpload extends StatefulWidget {
  final String title;
  final Profile myProfile;
  final String capture_type;
  final List<CameraDescription> cams;

  CameraUpload(
      {Key key, this.myProfile, this.title, this.cams, this.capture_type = ''})
      :super(key: key);

  CameraState createState() => CameraState();
}

class CameraState extends State<CameraUpload> with TickerProviderStateMixin {
  CameraController controller;

  String imagePath = '';

  String videoPath = '';

  VideoPlayerController videoController;

  VoidCallback videoPlayerListener;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  bool flashOn = false;
  bool isRecord = false;
  bool swichView = false;
  bool _hasFlash = false;
  bool _isOn = false;
  double _intensity = 1.0;

  _changeState(bool state) {
    if (state) {
      state = false;
      setState(() {
        state = false;
      });
    }
    else {
      state = true;
      setState(() {
        state = true;
      });
    }
  }

  initPlatformState() async {
    bool hasFlash = await Lamp.hasLamp;
    print("Device has flash ? $hasFlash");
    setState(() {
      _hasFlash = hasFlash;
    });
  }

  Future _turnFlash() async {
    _isOn ? Lamp.turnOff() : Lamp.turnOn(intensity: _intensity);
    var f = await Lamp.hasLamp;
    setState(() {
      _hasFlash = f;
      _isOn = !_isOn;
    });
  }

  _intensityChanged(double intensity) {
    Lamp.turnOn(intensity: intensity);
    setState(() {
      _intensity = intensity;
    });
  }

  Animation<Color> animation;
  AnimationController pulseAnimController;
  final Tween colorTween =
  ColorTween(begin: Colors.redAccent, end: Colors.redAccent.shade100);

  final Tween colorTween2 =
  ColorTween(begin: Colors.green, end: Colors.tealAccent);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        key: _scaffoldKey,


        body: widget.capture_type == 'IP'
            ? new CameraEdit(url: imagePath,)
            : new GestureDetector(
          onDoubleTap: () {
            print(controller.description);
            if (swichView) {
              setState(() {
                swichView = true;
              });
              swichView = false;
              //front
              onNewCameraSelected(widget.cams[0]);
            }
            else {
              setState(() {
                swichView = false;
              });
              swichView = true;
              //back
              onNewCameraSelected(widget.cams[1]);
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _cameraPreviewWidget(),
              new Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Align(alignment: Alignment.bottomCenter,
                    child: _captureControlRowWidget(),)),

            ],
          ),)
    );
  }

  @override
  void initState() {
    if (widget.capture_type == 'IP')
      getImage();
    initPlatformState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    onNewCameraSelected(widget.cams[0]);
    pulseAnimController = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);

    animation = colorTween2.animate(pulseAnimController)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    pulseAnimController.forward();
    pulseAnimController.reverse();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imagePath = image.path;
    });
  }

  Widget _flashButton() {
    return new IconButton(onPressed: () {
      if (flashOn) {
        setState(() {
          flashOn = true;
        });
        flashOn = false;
      }
      else {
        setState(() {
          flashOn = false;
        });
        flashOn = true;
      }
    },
        icon: Icon(flashOn ? Icons.flash_on : Icons.flash_off,
          color: flashOn ? Colors.lightBlueAccent : Colors.grey, size: 32.0,)
    );
  }

  Widget _camSwitch() {
    return new IconButton(onPressed: () {
      if (swichView) {
        setState(() {
          swichView = true;
        });
        swichView = false;
        //front
        onNewCameraSelected(widget.cams[0]);
      }
      else {
        setState(() {
          swichView = false;
        });
        swichView = true;
        //back
        onNewCameraSelected(widget.cams[1]);
      }
    },
        icon: Icon(swichView
            ? getCameraLensIcon(widget.cams[0].lensDirection)
            : getCameraLensIcon(widget.cams[1].lensDirection),
          color: swichView ? Colors.grey : Colors.white70, size: 32.0,)
    );
  }

  var elapsedTime = new Stopwatch();
  double scale = 1.0;

  Widget _captureButton() {
    return InkWell(
      onDoubleTap: _turnFlash,
      onTap: () {
        if (isRecord) {
          //stop Record
          elapsedTime.stop();
          elapsedTime.reset();
          onStopButtonPressed();
          setState(() {
            isRecord = false;
          });
        }
        else {
          //take Pictue
          onTakePictureButtonPressed();
        }
      },
      onLongPress: () {
        onVideoRecordButtonPressed();
        elapsedTime.start();

        setState(() {
          isRecord = true;
        });
      },
      child: new Container(width: 120.0, height: 120.0,
        decoration: BoxDecoration(
          border: Border.all(
              width: 10.0, color: isRecord ? animation.value : Colors.white70),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: isRecord ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[TimerText(stopwatch: elapsedTime,
                style: TextStyle(
                    fontSize: 18.0, fontFamily: 'Jua', color: Colors.white70)),

              //isRecord?Icon(Icons.stop,color: Colors.red,size: 80.0,):new Container()
            ]) : new Container(),

      ),);
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return new GestureDetector(
        // onVerticalDragStart: (d){print(d.globalPosition.distance); setState(() {scale += d.globalPosition.distance/100;});scale=d.globalPosition.distance/100;},
          onScaleUpdate: (one) {
            print(one.scale);
            scale = one.scale;
            setState(() {
              scale = one.scale;
            });
          },

          child: new Transform.scale(
              scale: scale / controller.value.aspectRatio,
              child: new Center(
                child: new AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: new CameraPreview(controller)),
              )

          ));
    }
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return new Align(
      alignment: Alignment.bottomCenter,
      child: videoController == null && imagePath == null
          ? null
          : SizedBox(
        child: (videoController == null)
            ? InkWell(
            onTap: () {
              _edit(context, imagePath, 'pic');
            },
            child: new Card(
              color: animation.value,
              margin: EdgeInsets.zero,
              elevation: 10.0,
              child: new Stack(
                  children: <Widget>[
                    new Center(
                      child: FadeInImage(
                          placeholder: AssetImage('images/ajax-loader.gif'),
                          image:
                          new FileImage(new File(imagePath),),
                          fit: BoxFit.cover),
                    ),
                    new Center(

                        child: Text('Tap to edit', style: TextStyle(
                            fontFamily: 'Jua',
                            color: Colors.white70,
                            fontSize: 10.0),)),
                    new Align(child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Icon(
                        Icons.send, color: Colors.white70, size: 10.0,),))
                  ]
              ),

            ))
            : InkWell(
          onTap: () {
            _edit(context, videoPath, 'vid');
          },
          child: new Card(
            elevation: 10.0,

            child: new Stack(
                children: <Widget>[
                  new AspectRatio(
                      aspectRatio: videoController.value.size != null
                          ? videoController.value.aspectRatio
                          : 1.0,
                      child: new VideoPlayer(videoController)),

                  new Align(child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text(
                        videoController != null ? TimerTextFormatter.mmSSformat(
                            videoController.value.duration.inMilliseconds) : '',
                        style: TextStyle(color: Colors.white70,
                          fontFamily: 'Jua',
                          fontSize: 20.0,),))),
                  new Center(child: Text('Edit', style: TextStyle(
                      fontFamily: 'Jua',
                      color: Colors.white70,
                      fontSize: 6.0),)),
                  new Align(child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Icon(
                      Icons.send, color: Colors.white70, size: 6.0,),))
                ]
            ),

          ),),
        width: 50.0,
        height: 70.0,
      ),

    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _thumbnailWidget(),
        _captureButton(),
        Padding(
            padding: const EdgeInsets.only(bottom: 20.0), child: _camSwitch())
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    videoController.dispose();
    pulseAnimController.dispose();
    super.dispose();
  }


  @override
  void deactivate() {
    super.deactivate();
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    if (widget.cams.isEmpty) {
      return const Text('No camera found');
    } else {
      for (CameraDescription cameraDescription in widget.cams) {
        toggles.add(
          new SizedBox(
            width: 90.0,
            child: new RadioListTile<CameraDescription>(
              title:
              new Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: controller?.description,
              value: cameraDescription,
              onChanged: controller != null && controller.value.isRecordingVideo
                  ? null
                  : onNewCameraSelected,
            ),
          ),
        );
      }
    }

    return new Row(children: toggles);
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = new CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {

      });
      if (filePath != null) showInSnackBar('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recorded to: $videoPath');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      print('stMsss');
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      print('Viderr');
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future _edit(BuildContext context, String url, String type) async {
    //Navigator.pop(context);
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CameraEdit(url: url, type: type);
        },
        fullscreenDialog: false
    ));
  }


  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
    new VideoPlayerController.file(new File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/24Hours';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Future<Null> _flipImage(File imageFile) async {
    img.Image image = img.decodeImage(imageFile.readAsBytesSync());
    img.Image flipImage = await img.flip(image, 1);
    setState(() {
      imageFile = new File(imageFile.path)
        ..writeAsBytesSync(img.encodePng(flipImage));
    });
  }
}

class TimerText extends StatefulWidget {
  TimerText({this.stopwatch, this.style});

  final Stopwatch stopwatch;
  final TextStyle style;

  TimerTextState createState() =>
      new TimerTextState(stopwatch: stopwatch, style: style);
}

class TimerTextState extends State<TimerText> {

  Timer timer;
  final Stopwatch stopwatch;
  final TextStyle style;

  TimerTextState(
      {this.stopwatch, this.style: const TextStyle(fontSize: 12.0)}) {
    timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
  }

  void callback(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle timerTextStyle = style;
    String formattedTime = TimerTextFormatter.mmSSformat(
        stopwatch.elapsedMilliseconds);
    return new Text(formattedTime, style: timerTextStyle);
  }
}

class TimerTextFormatter {
  static String format(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr.$hundredsStr";
  }

  static String mmSSformat(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  static String HHmmSSformat(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hr = (seconds / 24).truncate();

    String hrsStr = (hr % 24).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hrsStr:$minutesStr:$secondsStr";
  }

  static String HHmmformat(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hr = (seconds / 24).truncate();

    String hrsStr = (hr % 24).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hrsStr:$minutesStr";
  }
}
