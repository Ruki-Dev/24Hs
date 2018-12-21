import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:polygon_clipper/polygon_path_drawer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:twenty_four_hours/Gym/Models/Exercise.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Gym/Models/Workout.dart';
import 'package:twenty_four_hours/Widget_Assets/CycleView.dart';
import 'package:twenty_four_hours/Widget_Assets/ExerciseBubble.dart';
import 'package:twenty_four_hours/Widget_Assets/Following.dart';
import 'package:twenty_four_hours/Widget_Assets/HexagonDrawer.dart';
import 'package:twenty_four_hours/Widget_Assets/ImageIcons.dart';
import 'package:twenty_four_hours/Widget_Assets/WorkoutWidget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:twenty_four_hours/Widget_Assets/auto_size_text.dart';

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

  bool playSlide=true;
  List<Widget> completedWorkouts=new List<Widget>();
  num slideSpeed=4;
  int currentWrkout=0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    for(Workout w in profile.completedWorkouts)
      {
        
        completedWorkouts.add(new WorkoutWidget(w,profile,color: Colors.transparent,));
      }
    print("Starting complete");
    return new Scaffold(
      appBar: new AppBar(
        key:Key("completedAppbar"),
        backgroundColor: Colors.green,
        title: new Text("My Completed Workouts/Stats",style:new TextStyle(fontFamily: 'Exo')),
      ) ,
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
                          child: new AutoSizeText(FormatValue(profile.completedWorkouts.length).getValue(),style: num_style,softWrap: true,maxLines:1,maxFontSize: 40.0,minFontSize: 4.0,),
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
                              child: new Text(new NumberFormat("###.##").format(profile.workoutStats.averageKcal)+"Kcal",style: num_style2,softWrap: true,),
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
                              child: new Text(new NumberFormat("###.##").format(profile.workoutStats.currentWeight)+" Kg",style: num_style2,softWrap: true,),
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
                                AssetImage(MuscleGroup.translateNametoImg(profile.workoutStats.favouriteMuscle)),
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
                                child: new Text(new FormatValue(profile.workoutStats.strengthLvl).getValue(),style: num_style2,softWrap: true,),

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
        //  Positioned(
          //  bottom: 10.0,
           // child:
            //new ExerciseBubble(profile.completedWorkouts[0].exercises[0],size: 300.0,)
          new Align
                   (
            alignment: Alignment(0.5,0.7),

          child:new CarouselSlider(
                items: completedWorkouts.map((cw) {
                  return new Builder(
                    builder: (BuildContext context) {
                      return new Container(
                          width: MediaQuery.of(context).size.width,
                          margin: new EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: new BoxDecoration(
                              color: Colors.green,
                            borderRadius: BorderRadius.circular(5.0),
                            border:Border.all(width: 2.5,color:Colors.green)
                          ),
                          child: Container(child:SingleChildScrollView(child:cw))
                      );
                    },
                  );
                }).toList(),
                height: 280.0,
                updateCallback: (c){setState(() {
                  c=0;
                  if(c>=profile.completedWorkouts.length)
                    c=0;
                  else c++;
                  
                  currentWrkout=c;
                });},
                autoPlayDuration: Duration(seconds: 4),

                autoPlay: playSlide
            )),
            //new WorkoutWidget(profile.completedWorkouts[0],profile,),
//          ),
       Align(
         alignment: Alignment.topLeft,
    child: Row(
    children: <Widget>[
      Text("Slideshow: ",style: TextStyle(color: Colors.white),),
        Switch(onChanged: (play){setState(() {
          print(play);
    playSlide=play;
    });},
    activeColor: Colors.lightGreenAccent,
    value: playSlide,

    )

    ],
    )),
          Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: <Widget>[
                  Text("${currentWrkout+1}/${profile.completedWorkouts.length}",style: TextStyle(color: Colors.white),),

                ],
              )),

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