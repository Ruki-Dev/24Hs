import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';import 'package:flutter_test/flutter_test.dart';
import 'package:twenty_four_hours/Gym/Contribute/AddExercise.dart';
import 'package:twenty_four_hours/Gym/Contribute/AddFood.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
class ContributeMain extends StatefulWidget
{
  final Profile profile;
  ContributeMain({Key key,this.profile}):super(key:key);
  ContributeMainState createState()=>ContributeMainState();
}
class ContributeMainState extends State<ContributeMain>
{
   static TextStyle textStyle=new TextStyle(fontFamily: 'Chicle',fontSize: 32.0,color: Colors.white);
   List<Widget> modules=List<Widget>();

   @override
   void initState() {
     modules=[
       new InkWell( onTap:(){_openEx(context);},child:new Card(child: Container(height: 200.0,child:
       Stack(fit: StackFit.expand, children:<Widget>[ FadeInImage(placeholder: AssetImage('ajax-loader.gif'),image: AssetImage('assets/wrkout.gif'),fit: BoxFit.cover,),
       Container(child:Center(child:Text('Add Exercise',style: textStyle,)),color: Colors.red.withOpacity(0.3)),
       ])))),
       new InkWell(onTap:(){_openFd(context);}, child: Card(child: Container(child:Stack( children:<Widget>[ FadeInImage(placeholder: AssetImage('ajax-loader.gif'),image: AssetImage('assets/food2.gif'),fit: BoxFit.contain,),
       Container(child:Center(child:Text('Add Food',style: textStyle,)),color: Colors.teal.withOpacity(0.3)),])))),
       new InkWell( child: new Card(child: Container(child: Stack( children:<Widget>[FadeInImage(placeholder: AssetImage('ajax-loader.gif'),image: AssetImage('assets/sport.gif'),fit: BoxFit.cover,),
       Container(child:Center(child:Text('Add Sport Drill',style: textStyle,)),color: Colors.black.withOpacity(0.3)),])))),
       new InkWell( child: new Card(color:Colors.midnight_main,child: Container(child: Stack( children:<Widget>[FadeInImage(placeholder: AssetImage('ajax-loader.gif'),image: AssetImage('assets/glossary.gif'),fit: BoxFit.contain,),
       Container(child:Center(child:Text('Add to Glossary',style: textStyle,)),color: Colors.black.withOpacity(0.3)),])))),
       new InkWell( child:new Card(color:Colors.purple,child: Container(child: Stack( children:<Widget>[FadeInImage(placeholder: AssetImage('ajax-loader.gif'),image: AssetImage('assets/yoga.gif'),fit: BoxFit.contain,),
       Container(child:Center(child:Text('Add Stretch',style: textStyle,)),color: Colors.purpleAccent.withOpacity(0.3)),])))),



     ];
   }

   @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.midnightTextPrimary,title: Text('Select your Contribution type'),),
      backgroundColor: Colors.black45,
      body: new GridView.count(
        padding: const EdgeInsets.only(top: 5.0),
        crossAxisCount: 1,
        children: new List.generate(

          // profile.gallery.pictures.length
            modules.length, (index) {
          return new Padding(
              padding: const EdgeInsets.all(2.0),
              child:modules[index]);
        }),


    ));
  }
   Future _openEx(BuildContext context) async {
     Navigator.of(context).push(new MaterialPageRoute<Null>(
         builder: (BuildContext context) {
           return new AddExercise(
             //profile: widget.profile,
           );
         },
         fullscreenDialog: true));
   }
   Future _openFd(BuildContext context) async {
     Navigator.of(context).push(new MaterialPageRoute<Null>(
         builder: (BuildContext context) {
           return new AddFood(
             //profile: widget.profile,
           );
         },
         fullscreenDialog: true));
   }

}