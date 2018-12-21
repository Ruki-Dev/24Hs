import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twenty_four_hours/Gym/Models/Exercise.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Gym/Models/Workout.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/homePage.dart';
import 'package:twenty_four_hours/Widget_Assets/CustomDivider.dart';
import 'package:twenty_four_hours/Widget_Assets/ExerciseBubble.dart';
import 'package:twenty_four_hours/Widget_Assets/ImageIcons.dart';
import 'package:twenty_four_hours/Widget_Assets/LevelIcon.dart';
import 'package:twenty_four_hours/Widget_Assets/auto_size_text.dart';
class WorkoutWidget extends StatefulWidget
{
  final Workout workout;
  final double size;
  final double width;
  final Color color;
  final Profile myProfile;
  WorkoutWidget(this.workout,this.myProfile,{this.size=300.0,this.width=2.5,this.color=Colors.white});
  WorkoutWidgetState createState()=>new WorkoutWidgetState(workout,myProfile,size: size,width: width,color: color);
}
class WorkoutWidgetState extends State<WorkoutWidget> with TickerProviderStateMixin
{
  final Workout workout;
  final double size;
  final double width;
  final Color color;
  final Profile myProfile;

  bool _downloaded;
WorkoutWidgetState(this.workout,this.myProfile,{this.size=300.0,this.width=2.5,this.color=Colors.transparent});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: (){},
      child: Container(
  height: size,
      width: size,

      decoration: BoxDecoration(
      borderRadius:new BorderRadius.circular(10.0),
      border: new Border.all(color: color,width: width)

      ),
      child:Stack(
        fit: StackFit.expand,
        children: <Widget>[

          DecoratedBox(
              decoration:BoxDecoration(
                  image:DecorationImage(
                      image:workout.imgUrl!=''?NetworkImage(workout.imgUrl):workout.exercises.first.imgurl!=''?NetworkImage(workout.exercises.first.imgurl):AssetImage('images/gym2.jpg'),
                      fit:BoxFit.cover,
                      repeat: ImageRepeat.noRepeat,
                      colorFilter: new ColorFilter.mode(Colors.mainscreenDark, BlendMode.color)
                  )
              )
          ),

    Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[

     exerciseBox(),
    aboutBox(),
    ],
    )
        /*
        c,*/
      ],
      )));

  }

  @override
  void initState() {
    _downloaded=isDownloaded();
  }

  Widget exerciseBox() {
    return Container(

      width:size,

      padding:const EdgeInsets.all(8.0),

      decoration: BoxDecoration(
        color: Colors.mainscreenDark,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(1.0),
          topRight: const Radius.circular(1.0)
        ),
       // border: Border.all(color: Colors.black87,width: 5.0),
        boxShadow: [BoxShadow(color: Colors.black54,offset: Offset(0.0,10.0),blurRadius: 20.0)]
      ),

    child:Column(
     mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        exercises(),
        Padding(
            padding: EdgeInsets.zero,
            child:new AutoSizeText('${workout.exercises.length+workout.superset.length} Excersises',maxLines:1,minFontSize:0.1,maxFontSize:16.0,style:TextStyle(fontFamily: "Exo",fontWeight: FontWeight.bold,color: Colors.amber))
        )
      ]),
    );
 }
  Widget informationBox(){
    return Container(

        child:Stack(
      fit:StackFit.expand,
      children: <Widget>[

        aboutBox()
      ],
    ));
  }
  String randomFontgenerator()
  {
    switch(rndNumber(1,23))
    {
      case 1:return 'Aclonica';
      case 2:return 'Acme';
      case 3:return 'Anton';
      case 4:return 'Audiowide';
      case 5:return 'Chela';
      case 6:return 'Chicle';
      case 7:return 'Engagement';
      case 8:return 'Exo';
      case 9:return 'Galada';
      case 10:return 'GochiHand';
      case 11:return 'Inconsolata';
      case 12:return 'IndieFlower';
      case 13:return 'Monoton';
      case 14:return 'Pacifico';
      case 15:return 'PassionOne';
      case 16:return 'PoorStory';
      case 17:return 'Lobster';
      case 18:return 'Kaushan';
      case 19:return 'Knewave';
      case 20:return 'Pattaya';
      case 21:return 'Jua';
      case 22:return 'ExoLight';
      case 23:return 'ExoBold';


    }
  }
  num rndNumber(num min, num max) {
    return new Random().nextInt(max - min + 1) + min;
  }
  Widget aboutBox(){
    List<Widget> icns=new List();
    for(String m in workout.muscles)
    {
      print(m); icns.add(ImageIconsData.getIconbykeyword(m,size:this.size*0.08,color: Colors.amber));

    }

    Row  mgIcons=new Row(
        children:icns
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2.0),
          child:LevelIcon(workout.level,ic_size: size*0.1,),
        ),
       new Container(
         padding: const EdgeInsets.all(14.0),
          child:RichText(
            softWrap: true,
          text:TextSpan(
          children: [
              new TextSpan(text: workout.name.toUpperCase().trim(),
              style: new TextStyle(fontFamily:randomFontgenerator(),color:Colors.white,fontSize:size*0.05)),
              new TextSpan(text: " by ",style:new TextStyle(color:Colors.white)),
              new TextSpan(text:workout.creator.user.username,
              style:new TextStyle(color:Colors.amber,fontStyle:FontStyle.italic,decoration:TextDecoration.underline),
                recognizer: new TapGestureRecognizer()..
                onTap=(){
                  _openProfile(context,workout.creator);
                }
              )
            ])
        )),

       SingleChildScrollView(
            child:Text(
              workout.desc,
              style:TextStyle(fontStyle: FontStyle.italic,color: Colors.white70)
    )),
      new CustomDivider(length:size*0.2,thickness: width*1.2,color: Colors.white,),

    Padding(
          padding: const EdgeInsets.all(2.0),
          child:mgIcons
        ),
       _downloaded?new IconButton(icon: Icon(FontAwesomeIcons.checkCircle,color: Colors.green), onPressed: null):new IconButton(icon: Icon(Icons.file_download,color: Colors.white,size: 30.0,), onPressed: saveWorkout)
        ],
    );
  }
  void saveWorkout()
  {
    myProfile.savedWorkouts.add(workout);
    setState(() {
      _downloaded=isDownloaded();
    });

    //TODO save to database

  }
  bool isDownloaded()
  {
    if(myProfile.savedWorkouts!=null)
    for(Workout w in myProfile.savedWorkouts){
      if(w.id==workout.id&&w.id!='')return true;
    }
    return false;
  }
  Widget exercises(){
    List<Widget> exerciselist=new List<Widget>();
    for(Exercise e in workout.exercises)
      {
       // exerciselist.add(new ExerciseBubble(e,bcolor: Colors.amber,size: 60.0,));
        Widget container=new Container(


            decoration: BoxDecoration(

              //shape:BoxShape.circle,
              // borderRadius: BorderRadius.circular(12.0),
              //border: Border.all(color:color,width: width/2)
            ),
            child:Row(//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new ExerciseBubble(e,bcolor: Colors.amber,)
                   ],

        ));
        exerciselist.add(container);
      }
      int i=0;
    for(Superset sS in workout.superset)
        {i++;
          Widget container=new Container(

            key: Key(sS.first.name+'$i'),
            decoration: BoxDecoration(

              //shape:BoxShape.circle,
             // borderRadius: BorderRadius.circular(12.0),
              //border: Border.all(color:color,width: width/2)
            ),
            child:Row(//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Transform.rotate(
                angle:90.0,
                child:Divider(
                height: 5.0,
                color: Colors.amber,
                indent: 10.0,
              )
              ),
              new ExerciseBubble(sS.first,bcolor: Colors.amber,),
              new Icon(Icons.link,color: Colors.amber),
              new ExerciseBubble(sS.second,bcolor: Colors.amber.shade700,)
            ],)
          );
          exerciselist.add(container);
        }
      return Container(
          height:size*0.2,
          width: size,
          child:
            ListView(
            // This next line does the trick.

              scrollDirection: Axis.horizontal,
              children: exerciselist
          )
      );
  }
  Future _openProfile(BuildContext context, Profile p) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Homepage(myProfile: myProfile, profile: p);
        },
        fullscreenDialog: true));
  }
}