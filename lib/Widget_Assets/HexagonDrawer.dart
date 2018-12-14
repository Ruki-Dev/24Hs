import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_path_drawer.dart';

class HexagonOutline extends CustomPainter{
  Paint _paint;
  double width;
  Color color;
  StrokeCap capType;
  PaintingStyle style;
  Size size;
  final PolygonPathSpecs specs;
  final List<PolygonLine> polyLines;
  HexagonOutline(this.specs,this.polyLines,{this.size: const Size(80.0, 80.0),this.width,this.color,this.capType,this.style}){
    _paint=Paint()
        ..color=color
        ..strokeWidth=width
        ..strokeCap=capType
        ..style=style;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Path path = new PolygonPathDrawer(size: this.size, specs: specs).draw();

      canvas.drawPath(path, _paint);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }


}
class AnimHexagonOutlinePainter extends CustomPainter{
  Paint _paint;
  double width;
  Color color;
  StrokeCap capType;
  PaintingStyle style;
  Size size;
  final PolygonPathSpecs specs;
  final List<PolygonLine> polyLines;
  double fraction;
  AnimHexagonOutlinePainter(this.fraction,this.specs,this.polyLines,{this.size: const Size(80.0, 80.0),this.width,this.color,this.capType,this.style}){
    _paint=Paint()
      ..color=color
      ..strokeWidth=width
      ..strokeCap=capType
      ..style=style;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Path path = new PolygonPathDrawer(size: this.size*fraction, specs: specs).draw();
    polyLines.forEach((PolygonLine pl){
      canvas.drawPath(path, _paint);
    });

  }

  @override
  bool shouldRepaint(AnimHexagonOutlinePainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.fraction != fraction;
  }


}

class PolygonLine {
  final Color color;

  PolygonLine({
    @required this.color
  });
}
class AnimateHexagonOutline extends StatefulWidget{

  double width;
  Color color;
  StrokeCap capType;
  PaintingStyle style;
  final PolygonPathSpecs specs;
  final List<PolygonLine> polyLines;
  Size size;
  AnimateHexagonOutline(this.specs,this.polyLines,{this.size,this.width,this.color,this.capType,this.style});
  @override
  AnimateHexState createState()=>AnimateHexState(specs,polyLines,size:size,width:width,color: color,capType: capType,style: style);

}
class AnimateHexState extends State<AnimateHexagonOutline> with SingleTickerProviderStateMixin
{

  double width;
  Color color;
  StrokeCap capType;
  PaintingStyle style;
  final PolygonPathSpecs specs;
  final List<PolygonLine> polyLines;
  double _fraction = 0.0;
  Animation<double> animation;Size size;

  AnimateHexState(this.specs,this.polyLines,{this.size,this.width,this.color,this.capType,this.style});


    @override
  void initState() {
    super.initState();
    var controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          _fraction = animation.value;
        });
      });

    controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: AnimHexagonOutlinePainter(_fraction,specs,polyLines,size:size,width:width,color: color,capType: capType,style: style));
  }
}