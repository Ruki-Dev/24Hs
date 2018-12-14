import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:polygon_clipper/polygon_path_drawer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:twenty_four_hours/Gym/Models/Exercise.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Widget_Assets/ExerciseBubble.dart';
import 'package:twenty_four_hours/Widget_Assets/HexagonDrawer.dart';
import 'package:twenty_four_hours/Widget_Assets/ImageIcons.dart';

class Completed extends StatefulWidget
{
  final Profile profile;
  Completed({this.profile});
  CompletedState createState()=>new CompletedState(profile: profile);
}

Widget genrateBluredImage(DecorationImage dim) {
  return new Container(
    decoration: new BoxDecoration(
      image: dim
    ),
    //I blured the parent conainer to blur background image, you can get rid of this part
    child: new BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: new Container(
        //you can change opacity with color here(I used black) for background.
        decoration: new BoxDecoration(color: Colors.black.withOpacity(0.5)),
      ),
    ),
  );
}
class CompletedState extends State<Completed>
{
  final Profile profile;
  CompletedState({this.profile});
  final TextStyle num_style=new TextStyle(color: Colors.lightGreenAccent,fontFamily: "Exo",fontSize: 40.0);
  final TextStyle txt_style=new TextStyle(color: Colors.green,fontFamily: "Kaushan",fontSize: 12.0);
  final TextStyle num_style2=new TextStyle(color: Colors.lightGreenAccent,fontFamily: "Exo",fontSize: 14.0);
  final TextStyle txt_style2=new TextStyle(color: Colors.green,fontFamily: "Kaushan",fontSize: 6.0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("Starting complete");
    return new Scaffold(
      key: Key("CompletedWorkout"),
      body: new Stack(
        fit: StackFit.expand,
        key: Key("CWstack1"),
        alignment: Alignment.center,
        children: <Widget>[
          genrateBluredImage(DecorationImage(
                 image:AssetImage('images/gym1.jpg'),
               fit:BoxFit.cover,
               repeat: ImageRepeat.noRepeat,
               colorFilter: new ColorFilter.mode(Colors.mainscreenDark, BlendMode.modulate)
           )),


          new Padding
        (
            padding: const EdgeInsets.only(top:30.0),
             child: new Align(
            alignment: Alignment.topCenter,
            child:Wrap(
              alignment: WrapAlignment.center,
            children: <Widget>[
                HexagonOutlined(
                  new Container(
                  child:new Column(
                    children: <Widget>[
                      Shimmer.fromColors(
                          baseColor: Colors.lightGreenAccent,
                          highlightColor: Colors.green.shade100,
                          period: Duration(seconds: 2),
                          child: new Text("0",style: num_style,softWrap: true,),
                            ),
                         new Text("Workouts Completed",style: txt_style,softWrap: true,),
                      Padding(padding: const EdgeInsets.all(6.0)),
                      Shimmer.fromColors(
                        baseColor: Colors.midnightTextPrimary,
                        highlightColor: Colors.yellow.shade100,
                        child:Icon(FontAwesomeIcons.checkCircle,size:12.0,color: Colors.midnightTextPrimary,)
                      )
                    ],
                  )
                  ),
                  size: new Size(150.0,150.0),
                  color: Colors.green,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Wrap(
                    spacing: 6.0,
                    runSpacing: 4.0,
                    direction: Axis.horizontal,

                    children: <Widget>[
                    _wStats(
                        new Column(
                          children: <Widget>[
                            Padding(padding: const EdgeInsets.only(top:6.0)),
                            Shimmer.fromColors(
                              baseColor: Colors.midnightTextPrimary,
                              highlightColor: Colors.yellow.shade100,
                              period: Duration(seconds: 2),
                              child: new Text("0Kcal",style: num_style2,softWrap: true,),
                            ),
                            new Text("Total Kcal",style: txt_style2,softWrap: true,),
                            Padding(padding: const EdgeInsets.all(2.0)),
                            Shimmer.fromColors(
                                baseColor: Colors.red,
                                highlightColor: Colors.orange.shade200,
                                child:Icon(FontAwesomeIcons.burn,size:12.0,color: Colors.midnightTextPrimary,)
                            )
                          ],
                        )
                    ),
                    _wStats(
                        new Column(
                          children: <Widget>[
                            Padding(padding: const EdgeInsets.only(top:6.0)),
                            Shimmer.fromColors(
                              baseColor: Colors.midnightTextPrimary,
                              highlightColor: Colors.yellow.shade100,
                              period: Duration(seconds: 2),
                              child: new Text("0 Kg",style: num_style2,softWrap: true,),
                            ),
                            new Text("Avg Weight",style: txt_style2,softWrap: true,),
                            Padding(padding: const EdgeInsets.all(2.0)),
                            Shimmer.fromColors(
                                baseColor: Colors.red,
                                highlightColor: Colors.orange.shade200,
                                child:Icon(FontAwesomeIcons.weight,size:12.0,color: Colors.midnightTextPrimary,)
                            )
                          ],
                        )
                    ),
                    _wStats(
                        new Column(
                          children: <Widget>[
                            Padding(padding: const EdgeInsets.only(top:2.0)),
                            Shimmer.fromColors(
                              baseColor: Colors.midnightTextPrimary,
                              highlightColor: Colors.yellow.shade100,
                              period: Duration(seconds: 2),
                              child:ImageIcon(
                                AssetImage("assets/ic_mg/ic_chest.png"),
                              )
                            ),
                            new Text("Favourite Muscle",style: txt_style2,softWrap: true,),
                            Padding(padding: const EdgeInsets.all(2.0)),
                            Shimmer.fromColors(
                                baseColor: Colors.red,
                                highlightColor: Colors.orange.shade200,
                                child:Icon(FontAwesomeIcons.heart,size:12.0,color: Colors.midnightTextPrimary,)
                            )
                          ],
                        )
                    ),
                    _wStats(
                        new Column(
                          children: <Widget>[
                            Padding(padding: const EdgeInsets.only(top:6.0)),
                            Shimmer.fromColors(
                                baseColor: Colors.midnightTextPrimary,
                                highlightColor: Colors.yellow.shade100,
                                period: Duration(seconds: 2),
                                child: new Text("1k",style: num_style2,softWrap: true,),

                            ),
                            new Text("Strength Level",style: txt_style2,softWrap: true,),
                            Padding(padding: const EdgeInsets.all(2.0)),
                            Shimmer.fromColors(
                                baseColor: Colors.red,
                                highlightColor: Colors.orange.shade200,
                                child:Icon(FontAwesomeIcons.dumbbell,size:14.0,color: Colors.midnightTextPrimary,)
                            )
                          ],
                        )
                    )
                  ],),
                  )
                )
                   ],

            )
          )
          ),
          Center(
            child: new ExerciseBubble(new Exercise(
              "Chest Press",
              "",
              "",
              ["Chest"],
              "",
              "",
              "intermediate",
              3,
              12,
              30.0,
              new Category().category[0],
              null,
              new Duration(seconds:30),
              null,
              ''
            )),
          )

        ],
      ),
    );
  }

Widget _wStats(Widget child)
{
  return Stack(

    overflow: Overflow.visible,
    children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: new Border.all(color: Colors.amberAccent,width:4.0),



          ),
          child: Align(
          alignment: Alignment.center,
          child:Padding(
          padding: const EdgeInsets.all(10.0),
          child:Container(
            width: 52.0,
           height: 52.0,
           child:child
          ),
        ))
        )


    ],
  );
}
}
class HexagonOutlined extends StatelessWidget
{
  Color color;
  Size size;
  double width;
  Widget _child;


  HexagonOutlined( this._child,{this.color:Colors.midnightTextPrimary, this.size:const Size(100.0,100.0), this.width=4.0});
  static int sides=6;
  static double rotate=0.0;
  static double borderRadius=5.0;
  PolygonPathSpecs specs = new PolygonPathSpecs(
    sides: sides < 3 ? 3 : sides,
    rotate: rotate,
    borderRadiusAngle: borderRadius,
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(

      overflow: Overflow.visible,
      children: <Widget>[
        new AnimateHexagonOutline(specs,[new PolygonLine(color:color)],size:size,width:width,color: color,capType:StrokeCap.square,style:PaintingStyle.stroke),

      Container(height:size.height, width:size.width),
        Positioned(
          top: size.height/10+10,
          left: size.width/10 +12,
          child: new Container(width:size.width-50,height:size.height-50,child:new Center(child:_child)),

        ),



      ],
    );
  }

}