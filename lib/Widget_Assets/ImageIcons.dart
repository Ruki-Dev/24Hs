import 'package:flutter/material.dart';
import 'package:twenty_four_hours/Gym/Models/Exercise.dart';
class ImageIcons extends StatelessWidget
{
  final Color color;
  
  final Text label;
  final ImageProvider image;
  final double size;
  ImageIcons({@required this.image,this.size,this.color:Colors.white,this.label});

  @override
  Widget build(BuildContext context) {
    return
            CircleAvatar(radius: size+1,

              child:
            Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children:<Widget>[

                  new Padding(padding:const EdgeInsets.all(2.0),child:ImageIcon(image,color:color,size:size*1.5),),


    new Expanded(child:label)]),
              backgroundColor: Colors.mainscreenDark,
    );
  }

}
class ImageIconsData
{
  static TextStyle ts=new TextStyle(fontFamily: 'Lobster',color: Colors.white,fontSize: 32.0);

  static Widget CHESTICON({Color color=Colors.midnightTextPrimary, double size,Color textColor=Colors.white}){return ImageIcons(image: AssetImage(MuscleGroup.muscleGroups_ic[0]),color: color,label:Text('CHEST',style: new TextStyle(fontFamily: 'Audiowide',color:textColor,fontSize:size*0.2),overflow: TextOverflow.fade,),size: size,);}
  static Widget COREICON({Color color=Colors.midnightTextPrimary, double size,Color textColor=Colors.white}){return ImageIcons(image: AssetImage(MuscleGroup.muscleGroups_ic[1]),color: color,label:Text('CORE',style: new TextStyle(fontFamily: 'Audiowide',color:textColor,fontSize:size*0.2),overflow: TextOverflow.fade,),size: size);}
  static Widget BICEPICON({Color color=Colors.midnightTextPrimary, double size,Color textColor=Colors.white}){return ImageIcons(image: AssetImage(MuscleGroup.muscleGroups_ic[2]),color: color,label:Text('BICEPS',style: new TextStyle(fontFamily: 'Audiowide',color:textColor,fontSize:size*0.2),overflow: TextOverflow.fade,),size: size);}
  static Widget TRICEPICON({Color color=Colors.midnightTextPrimary, double size,Color textColor=Colors.white}){return ImageIcons(image: AssetImage(MuscleGroup.muscleGroups_ic[3]),color: color,label:Text('TRICEPS',style: new TextStyle(fontFamily: 'Audiowide',color:textColor,fontSize:size*0.2),overflow: TextOverflow.fade,),size: size);}
  static Widget SHOULDERICON({Color color=Colors.midnightTextPrimary, double size,Color textColor=Colors.white}){return ImageIcons(image: AssetImage(MuscleGroup.muscleGroups_ic[4]),color: color,label:Text('SHOULDERS',style: new TextStyle(fontFamily: 'Audiowide',color:textColor,fontSize:size*0.2),overflow: TextOverflow.fade,),size: size);}
  static Widget BACKICON({Color color=Colors.midnightTextPrimary, double size,Color textColor=Colors.white}){return ImageIcons(image: AssetImage(MuscleGroup.muscleGroups_ic[5]),color: color,label:Text('BACK',style: new TextStyle(fontFamily: 'Audiowide',color:textColor,fontSize:size*0.2),overflow: TextOverflow.fade,),size: size);}
  static Widget TRAPSICON({Color color=Colors.midnightTextPrimary, double size,Color textColor=Colors.white}){return ImageIcons(image: AssetImage(MuscleGroup.muscleGroups_ic[6]),color: color,label:Text('TRAPS',style: new TextStyle(fontFamily: 'Audiowide',color:textColor,fontSize:size*0.2),overflow: TextOverflow.fade,),size: size);}
  static Widget GLUTEICON({Color color=Colors.midnightTextPrimary, double size,Color textColor=Colors.white}){return ImageIcons(image: AssetImage(MuscleGroup.muscleGroups_ic[7]),color: color,label:Text('GLUTES',style: new TextStyle(fontFamily: 'Audiowide',color:textColor,fontSize:size*0.2),overflow: TextOverflow.fade,),size: size);}
  static Widget QUADICON({Color color=Colors.midnightTextPrimary, double size,Color textColor=Colors.white}){return ImageIcons(image: AssetImage(MuscleGroup.muscleGroups_ic[8]),color: color,label:Text('QUADS',style: new TextStyle(fontFamily: 'Audiowide',color:textColor,fontSize:size*0.2),overflow: TextOverflow.fade,),size: size);}
  static Widget CALVESICON({Color color=Colors.midnightTextPrimary, double size,Color textColor=Colors.white}){return ImageIcons(image: AssetImage(MuscleGroup.muscleGroups_ic[9]),color: color,label:Text('CALVES',style: new TextStyle(fontFamily: 'Audiowide',color:textColor,fontSize:size*0.2),overflow: TextOverflow.fade,),size: size);}
  static Widget CARDIOICON({Color color=Colors.midnightTextPrimary, double size,Color textColor=Colors.white}){return ImageIcons(image: AssetImage(MuscleGroup.muscleGroups_ic[10]),color: color,label:Text('CARDIO',style: new TextStyle(fontFamily: 'Audiowide',color:textColor,fontSize:size*0.2),overflow: TextOverflow.fade,),size: size);}
  static Widget NOICON({Color color=Colors.grey, double size,Color textColor=Colors.white}){return Icon(Icons.close,color: color,);}


  static Widget getIconbykeyword(String ic_name,{Color color,double size,Color textColor=Colors.white})
  {
    switch(ic_name.toLowerCase())
    {
      case 'chest' : return CHESTICON(color: color,size:size,textColor:textColor);
      case 'core' : return COREICON(color: color,size:size,textColor:textColor);
      case 'biceps' : return BICEPICON(color: color,size:size,textColor:textColor);
      case 'triceps' : return TRICEPICON(color: color,size:size,textColor:textColor);
      case 'shoulder' : return SHOULDERICON(color: color,size:size,textColor:textColor);
      case 'back' : return BACKICON(color: color,size:size,textColor:textColor);
      case 'traps' : return TRAPSICON(color: color,size:size,textColor:textColor);
      case 'glutes' : return GLUTEICON(color: color,size:size,textColor:textColor);
      case 'quads' : return QUADICON(color: color,size:size,textColor:textColor);
      case 'calves' : return CALVESICON(color: color,size:size,textColor:textColor);
      case 'cardio' : return CARDIOICON(color: color,size:size,textColor:textColor);
      default : return NOICON(color: color,size:size,textColor:textColor);
    }
  }

}