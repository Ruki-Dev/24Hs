import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:twenty_four_hours/Gym/Models/Exercise.dart';
import 'package:twenty_four_hours/Widget_Assets/ImageIcons.dart';
import 'package:twenty_four_hours/Widget_Assets/LevelIcon.dart';

class ExerciseBubble extends StatelessWidget
{
   Exercise _exercise;
   Color bcolor;
   double width;//2
   double size;
   ExerciseBubble(this._exercise,{this.bcolor:Colors.white,this.width=2.5,this.size=400.0});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    initializeDateFormatting();
    return InkWell(
      onTap: (){},
      child: new Container(
        width: size,
      height: size,
      decoration: new BoxDecoration(
        //color: bcolor,
      shape: BoxShape.circle,
      border: new Border.all(
        color:bcolor,
        width:width,
      ),
    ),
    child: _main(),
    ));
  }
  Widget _main()
  {
    return Stack(
      fit: StackFit.expand,

      children:
  _elements()

    );
  }
  List<Widget> _elements()
   {
     return [
       _backgroundImage(),
      new Align(
            alignment: Alignment.topRight,
            child:_level()
        ),
      /*  new Align(
         alignment: Alignment.center,
         child:  about(),
       )*/
     ];
   }

  Widget _backgroundImage() {
    return Container(
        width: size/2,
        height: size/2,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: new Border.all(
              color:bcolor,
              width:width,
            ),
        image:DecorationImage(
          fit: BoxFit.contain,
        repeat: ImageRepeat.noRepeat,

        image:_exercise.imgurl!=''?new NetworkImage(_exercise.imgurl):new AssetImage('images/strong_man.png'),

        )));
  }
  Widget _level()
  {

    print("start");
    List<Widget> icns=new List();
    for(String m in _exercise.muscles)
    {
      print(m);
          }
    icns.add(ImageIconsData.getIconbykeyword("Chest",size:this.size*0.08,color: Colors.black45));

    Row  mgIcons=new Row(
      children:icns
    );
    return Container(
        width: size,
        child:Wrap(
        alignment: WrapAlignment.spaceEvenly,
      direction: Axis.horizontal,
        children: <Widget>[


       LevelIcon(_exercise.level,ic_size: size*0.08,),

        ImageIconsData.getIconbykeyword("chest",size:this.size*0.08,color: Colors.midnightTextPrimary)
      ],
    ));
  }
  TextStyle styler({String font='Exo',Color color=Colors.white,double size=12.0,double scaleFactor=0.08,bool bold=false,bool italic=false})
  {
    size=this.size*scaleFactor;
    return TextStyle(
      fontFamily: font,
      fontSize: size,
      fontWeight: bold?FontWeight.bold:FontWeight.normal,
      fontStyle: italic?FontStyle.italic:FontStyle.normal,
      color: color
    );
  }

  Widget about() {
    Text name=new Text(
      _exercise!=''?_exercise.name:'unknown',
      style: styler(size: 20.0,bold:true),

    );
    TextStyle antributestyler=styler(
      color: Colors.amberAccent,
      scaleFactor: 0.08/2
    );
    double icSize=size*0.08;

    return Container(
         width: size/2,
         height: size/2,

           decoration: new BoxDecoration(
             color: Colors.black38,
             borderRadius:new BorderRadius.circular(6.0),
             border: Border.all(color: bcolor,width: 3.0)

           ),
       child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        name,
        new Row(

         mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
             new Expanded(
                child:new Icon(Icons.threesixty,size: icSize,color: Colors.amber,)
             ),
            new Expanded(
            child:new Text('${_exercise.sets} Set(s)',style: antributestyler,)
            )
            ]
        ),
          new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          new Expanded(
            child: new Icon(Icons.close,size: icSize,color: Colors.amber,)
          ),
          new Expanded(
              child:new Text(_exercise.reps<=0&&_exercise.time!=null? new DateFormat.Hm().format(new DateTime.now()):'${_exercise.reps} Rep(s)',style: antributestyler,),
          )
    ]),
        new Row(
        mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
    new Expanded(
    child:new Icon(FontAwesomeIcons.dumbbell,size: icSize,color: Colors.amber,)),
    new Expanded(
    child:new Text(_exercise.weight<=0?'Body-weight':   new NumberFormat('###.##').format(_exercise.weight)+"Kg",style: antributestyler))
      ])
      ],
    ));
  }


}
class CustomRect extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    // TODO: implement getClip
    Rect rect = Rect.fromLTRB(-size.width, 0.0, size.width*2, size.height);
    return rect;
  }
  @override
  bool shouldReclip(CustomRect oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}