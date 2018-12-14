import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LevelIcon extends StatelessWidget
{
   String level;
  final double ic_size;
  final bool displayLabel;
   LevelIcon(this.level,{this.ic_size=80.0,this.displayLabel=false});
  Widget flame()
  {
    level=level.toLowerCase();
        double img_w=ic_size,img_h=ic_size;
        print(level);
      return Stack(
          fit: StackFit.loose,

          children: <Widget>[
            Align(alignment: Alignment.center,
                child:level=='advanced'?
                Image(image: AssetImage('assets/flame.gif'),color: Colors.red,height: img_h,width:img_w,):
                level=='intermediate'?Image(image: AssetImage('assets/flame.gif'),height: img_h*.8,width: img_w,):
                level=='beginner'?Image(image: AssetImage('assets/flame.gif'),color:Colors.green,height: img_h*0.5,width: img_w,):Container()),
            Center(
                child:    Icon(FontAwesomeIcons.fire,size: ic_size,color: level=='beginner'? Colors.green: level=='intermediate' ? Colors.orange: level=='advanced' ? Colors.red: Colors.black54,)
            )

          ]);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return displayLabel ?Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
      flame(),
      Text(level.toUpperCase(),style: TextStyle(fontFamily: 'Audiowide',color: level=='beginner'? Colors.green: level=='intermediate' ? Colors.orange: level=='advanced' ? Colors.red: Colors.black54),overflow: TextOverflow.ellipsis,),
    ],):flame();

  }

}