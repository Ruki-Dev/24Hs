import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twenty_four_hours/Gym/Models/Exercise.dart';
import 'package:twenty_four_hours/Widget_Assets/ImageIcons.dart';
import 'package:twenty_four_hours/Widget_Assets/Springy%20Slider.dart';
class AddExercise extends StatefulWidget
{
 AddExerciseState createState()=>AddExerciseState();
}
class AddExerciseState extends State<AddExercise> with TickerProviderStateMixin
{
  Exercise newExercise= new Exercise();
  String Name='',desc='';
  PageController pgController=new PageController(initialPage: 0);
  List<Widget>pages()
  {
    List<Widget>steps=[
      muscleSelection(),
      muscleSelection2(),
      about(),
      selectLevel(),
      image(),
      tips(),
      //completed()
    ];
    return steps;
  }
  TextEditingController name_cont=TextEditingController();
  TextEditingController desc_cont=TextEditingController();

  Widget about()
  {

    final TextStyle mainHeading=TextStyle(fontFamily: 'Lobster',color: Colors.black,fontSize: 32.0);
    final TextStyle bodyStyle=TextStyle(color: Colors.black87,fontSize: 14.0);
     TextField name=TextField(
      textAlign: TextAlign.center,
     controller: name_cont,
      maxLength: 20,
      style: mainHeading,
      onSubmitted: (s){Name=s;},
      decoration: InputDecoration(
        hintText: 'Enter Exercise Name',
        hintStyle: TextStyle(fontFamily: 'Lobster',color: Colors.grey),
        helperText: 'e.g Bench Press'
      ),
    );
     TextFormField body=new TextFormField(
      controller: desc_cont,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Discription & Directions',
        helperText: 'Talk About How to Perform the exercise and how effective it is',
        labelText: 'About Exercise',
      ),
      maxLines: 15,
    );
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         Padding(
            padding: const EdgeInsets.only(bottom: 5.0,left: 15.0,right: 15.0,top: 40.0),
            child: name,
          ),
         // new Divider(height: 4.0,color: Colors.grey,),
          new Expanded(child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0,left: 10.0,right: 10.0,top: 20.0),
            child: body,
          ))
        ],
      )

    );
  }
  Widget muscleSelection()
  {
    Widget tick = Icon(
      FontAwesomeIcons.checkCircle,
      color: Colors.white,
      size: 40.0,
    );
    TextStyle ts=new TextStyle(fontFamily: 'Lobster',color: Colors.white,fontSize: 32.0);
    int i=0;
    final List<Widget> muscles=new List<Widget>();
    for(String s in MuscleGroup.muscleGroups_ic)
      {
        print(MuscleGroup.muscleGroups[i]);
        muscles.add(InkWell(onTap:(){



          print(primeMus+'{{');
          setState(() {
            primeMus=MuscleGroup.translateImgtoName(s);
            print("hype$s");
            if(primeMus.isEmpty)
            {
              setState(() {
                currentComplete=false;
              });
            }
            else{
              print("Here");

              setState(() {
                currentComplete=true;
              });

            }

        });},child: Container(child: Stack(children: <Widget>[genrateBluredImage(s),new Center(child:Image(image:AssetImage(s),fit: BoxFit.contain,)),new Align(alignment:Alignment.bottomLeft,child:Container(width:500.0,color:Colors.black54,child:Text(MuscleGroup.muscleGroups[i],style:ts))),Align(
          alignment: Alignment.center,
          child: MuscleGroup.muscleGroups[i] == primeMus ? tick : new Container(),)],),),));
      i++;
      }

    return new GridView.count(
        padding: const EdgeInsets.only(top: 5.0),
    crossAxisCount: 2,
    children: new List.generate(

  // profile.gallery.pictures.length
  muscles.length, (index) {
  return new Padding(
  padding: const EdgeInsets.all(2.0),
  child:muscles[index]);
  }));



  }
VoidCallback listener;
  @override
  void initState() {
    pgController.addListener(listener);
    listener=(){


    };
    desc_cont.addListener((){
      if(name_cont.text.isEmpty&&desc_cont.text.isEmpty)
      { showInSnackBar('• Fill in NAME & ABOUT');
      setState(() {
        currentComplete=false;
      });
      }
      else{
        print("Here");

        setState(() {
          currentComplete=true;
        });

      }
    });
    name_cont.addListener((){
      if(name_cont.text.isEmpty&&desc_cont.text.isEmpty)
      { showInSnackBar('• Fill in NAME & ABOUT');
      setState(() {
        currentComplete=false;
      });
      }
      else{
        print("Here");

        setState(() {
          currentComplete=true;
        });

      }
    });

  }


  String primeMus='',secMus='';
  Widget muscleSelection2()
  {

    TextStyle ts=new TextStyle(fontFamily: 'Lobster',color: Colors.white,fontSize: 32.0);
    int i=0;
    final List<Widget> muscles=new List<Widget>();
    Widget tick = Icon(
      FontAwesomeIcons.checkCircle,
      color: Colors.green.withOpacity(0.8),
    );
    for(String s in MuscleGroup.muscleGroups_ic)
    {
      if(MuscleGroup.translateImgtoName(s)!=primeMus)muscles.add(

          InkWell(onTap:(){


              print(secMus+'{{');
              setState(() {
                secMus=MuscleGroup.translateImgtoName(s);

                if(secMus.isEmpty)
                {
                  setState(() {
                    currentComplete=false;
                  });
                }
                else{
                  print("Here");

                  setState(() {
                    currentComplete=true;
                  });

                }

              });
          },child: Container(child: Stack(children: <Widget>[new Center(child:Image(color:Colors.blueGrey,image:AssetImage(s),fit: BoxFit.contain,)),new Align(alignment:Alignment.bottomLeft,child:Container(width:500.0,color:Colors.black54,child:Text(MuscleGroup.muscleGroups[i],style:ts))),Align(
        alignment: Alignment.center,
        child: MuscleGroup.muscleGroups[i] == secMus ? tick : new Container(),
      ),],),),));
      i++;
    }
    muscles.add(InkWell(
      child: Container(color: Colors.redAccent,child: Center(child: Text('NONE',style: ts,)),),));

    return new GridView.count(
        padding: const EdgeInsets.only(top: 5.0),
        crossAxisCount: 2,
        children: new List.generate(

          // profile.gallery.pictures.length
            muscles.length, (index) {
          return new Padding(
              padding: const EdgeInsets.all(2.0),
              child:muscles[index]);
        }));



  }

  String level='';
  Widget Flame(String level,{double ic_size=80.0})
  {
    double img_w=ic_size,img_h=ic_size;
    return Stack(
      fit: StackFit.expand,
        children: <Widget>[
        Align(alignment: Alignment.center,
    child:level=='advanced'?
        Image(image: AssetImage('assets/flame.gif'),color: Colors.red,height: img_h+20,width:img_w+20,):
  level=='intermediate'?Image(image: AssetImage('assets/flame.gif'),height: img_h+10,width: img_w+10,):
  level=='beginner'?Image(image: AssetImage('assets/flame.gif'),color:Colors.green,height: img_h,width: img_w,):Container()),
        Center(
          child:    Icon(FontAwesomeIcons.fire,size: ic_size,color: level=='beginner'? Colors.green: level=='intermediate' ? Colors.orange: level=='advanced' ? Colors.red: Colors.black54,)
        )

        ]);

  }
  TextEditingController reccomendation=TextEditingController();
  TextEditingController sets=TextEditingController();

  TextEditingController reps=TextEditingController();

  TextEditingController weight=TextEditingController();

  Widget tips()
  {
    TextStyle heading=TextStyle(fontFamily: 'Chicle',fontSize: 30.0,color: Colors.mainscreenDark);
    TextStyle ts=TextStyle(fontSize: 14.0,color: Colors.black45);

    var header=new Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Icon(Icons.wb_incandescent,color: Colors.mainscreenDark,size: 30.0,),Text('Tips & Recomendations',style: heading,)],);
    return Card(


        child:ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),


        children: <Widget>[
        Padding(
        padding: const EdgeInsets.all(10.0), child:new Card(color:Colors.midnightTextPrimary,child:Center(child: header,))
    ),
    Padding(
    padding: const EdgeInsets.all(20.0), child:
  new TextFormField(
    controller: reccomendation,
    decoration: const InputDecoration(
    border: OutlineInputBorder(),
  hintText: 'Any Reccomendation to the User?',
  helperText: 'Any Tips',
  labelText: 'Reccomdation',
  ),
  maxLines: 5,
  )),

        Padding(
            padding: const EdgeInsets.all(20.0), child:
            new TextField(
              textAlign: TextAlign.center,
            controller: sets,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Re. Sets',
              helperText: 'This is just your Preset sets',
              labelStyle: TextStyle(color: Colors.mainscreenDark,fontSize: 26.0),

              suffixText: 'Sets',
              suffixStyle:const TextStyle(color: Colors.mainscreenDark),
              hintText: '--',
              hintStyle: TextStyle(color: Colors.mainscreenDark,fontSize: 26.0),
            ),
            keyboardType: TextInputType.number,


          )),
        Padding(
            padding: const EdgeInsets.all(20.0), child:
        new TextField(
          controller: reps,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: 'Re. Reps',
            helperText: 'This is just your Preset reps',
            labelStyle: TextStyle(color: Colors.mainscreenDark,fontSize: 26.0),
            suffixText: 'Reps',
            suffixStyle:const TextStyle(color: Colors.mainscreenDark),
            hintText: '--',
            hintStyle: TextStyle(color: Colors.mainscreenDark,fontSize: 26.0),
          ),
          keyboardType: TextInputType.number,


        )),
        Padding(
            padding: const EdgeInsets.all(20.0), child:
        new TextField(
          controller: weight,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: 'Re. Weight',
            labelStyle: TextStyle(color: Colors.mainscreenDark,fontSize: 26.0),
            helperText: 'This is just your recommended Min Weight',
            suffixText: 'Kg',
            suffixStyle:const TextStyle(color: Colors.mainscreenDark),
            hintText: '--',
            hintStyle: TextStyle(color: Colors.mainscreenDark,fontSize: 26.0),
          ),
          keyboardType: TextInputType.number,


        ))
        ]
    ),

    );
  }
  Widget selectLevel()
  {

    TextStyle ts=new TextStyle(fontFamily: 'Lobster',color: Colors.black87,fontSize: 10.0);
    TextStyle tss=new TextStyle(fontFamily: 'Lobster',color: Colors.black45,fontSize: 20.0);

    return Card(child: Stack(
      children: <Widget>[

 Align(alignment: Alignment.center,heightFactor:1.85,widthFactor:2.8,child:level=='advanced'?Image(image: AssetImage('assets/flame.gif'),color: Colors.red,height: 250.0,width: 250.0,):new Container()),
 Align(alignment: Alignment.center,heightFactor:2.9,widthFactor:2.8,child:level=='intermediate'?Image(image: AssetImage('assets/flame.gif'),height: 180.0,width: 180.0,):new Container()),
 Align(alignment: Alignment.center,child:level=='beginner'?Image(image: AssetImage('assets/flame.gif'),color:Colors.green,height: 120.0,width: 120.0,):new Container()),
      new Center(child:new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(FontAwesomeIcons.fire,size: 120.0,color: level=='beginner'? Colors.green: level=='intermediate' ? Colors.orange: level=='advanced' ? Colors.red: Colors.black54,), Text(level.toUpperCase(),style: tss,),])),
        new Align(
              alignment:Alignment.bottomCenter,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      IconButton(onPressed:(){
                        if(level.isEmpty)
                        { showInSnackBar('• Pick a LEVEL');
                        setState(() {
                          currentComplete=false;
                        });
                        }
                        else{
                          print("Here");

                          setState(() {
                            currentComplete=true;
                          });

                        }
                        setState(() {
                        level='beginner';
                      });
                      },icon: Icon(FontAwesomeIcons.fire,color: Colors.green),),
                      FlatButton(onPressed:(){setState(() {
                        if(level.isEmpty)
                        { showInSnackBar('• Pick a LEVEL');
                        setState(() {
                          currentComplete=false;
                        });
                        }
                        else{
                          print("Here");

                          setState(() {
                            currentComplete=true;
                          });

                        }
                        level='beginner';
                      });
                      },child: Text('BEGINNER',style: ts,),)
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      IconButton(onPressed:(){
                        if(level.isEmpty)
                        { showInSnackBar('• Pick a LEVEL');
                        setState(() {
                          currentComplete=false;
                        });
                        }
                        else{
                          print("Here");

                          setState(() {
                            currentComplete=true;
                          });

                        }setState(() {
                        level='intermediate';
                      });
                      },icon: Icon(FontAwesomeIcons.fire,color: Colors.orange),),
                      FlatButton(onPressed:(){
                        if(level.isEmpty)
                        { showInSnackBar('• Pick a LEVEL');
                        setState(() {
                          currentComplete=false;
                        });
                        }
                        else{
                          print("Here");

                          setState(() {
                            currentComplete=true;
                          });

                        }
                        setState(() {
                        level='intermediate';
                      });
                      },child: Text('INTERMEDIATE',style: ts,),)
                    ],
                  ),

                  new Column(
                    children: <Widget>[
                      IconButton(onPressed:(){
                        if(level.isEmpty)
                        { showInSnackBar('• Pick a LEVEL');
                        setState(() {
                          currentComplete=false;
                        });
                        }
                        else{
                          print("Here");

                          setState(() {
                            currentComplete=true;
                          });

                        }
                        setState(() {
                        level='advanced';
                      });
                      },icon: Icon(FontAwesomeIcons.fire,color: Colors.red),),
                      FlatButton(onPressed:(){
                        if(level.isEmpty)
                        { showInSnackBar('• Pick a LEVEL');
                        setState(() {
                          currentComplete=false;
                        });
                        }
                        else{
                          print("Here");

                          setState(() {
                            currentComplete=true;
                          });

                        }
                        setState(() {
                        level='advanced';
                      });
                      },child: Text('ADVANCED',style: ts,),)
                    ],
                  )

                ],

              ),

            ),
     //  Flame('advanced',ic_size: 140.0)


    ]));

  }
  getLevel(String s)
  {
    setState(() {
      level=s;
      if(level.isEmpty)
      { showInSnackBar('• Pick a LEVEL');
      setState(() {
        currentComplete=false;
      });
      }
      else{
        print("Here");

        setState(() {
          currentComplete=true;
        });

      }
    });
  }
  int completedstep=0;
  String prevPage='';
  bool prevComplete=false,currentComplete=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(backgroundColor: Colors.transparent,title:Text('${completedstep+1}/6 Steps'),actions: <Widget>[IconButton(icon:currentComplete?Icon(FontAwesomeIcons.angleDoubleRight,color: Colors.lightGreenAccent,):Icon(Icons.info,color: Colors.grey,))],),
   // floatingActionButton: FloatingActionButton.extended(onPressed:(){pgController.jumpToPage(completedstep+1);},icon: new Icon(FontAwesomeIcons.angleDoubleRight),label:Text('NEXT'),backgroundColor: currentComplete?Colors.green:Colors.grey,),
    /*  persistentFooterButtons: <Widget>[
        completedstep!=1? FloatingActionButton.extended(onPressed:(){pgController.jumpToPage(completedstep-1);},icon: new Icon(FontAwesomeIcons.angleDoubleLeft),label:Text(prevPage),backgroundColor: prevComplete?Colors.teal:Colors.red,):FloatingActionButton(child: Icon(Icons.close),backgroundColor: Colors.grey,)
       //completedstep!=1? Align(alignment: Alignment.bottomLeft,child: FloatingActionButton.extended(onPressed:(){pgController.jumpToPage(completedstep-1);},icon: new Icon(FontAwesomeIcons.angleDoubleLeft),label:Text(prevPage),backgroundColor: prevComplete?Colors.teal:Colors.red,),):new Container(),
      //  Align(alignment: Alignment.bottomRight,child: FloatingActionButton.extended(onPressed:(){pgController.jumpToPage(completedstep+1);},icon: new Icon(FontAwesomeIcons.angleDoubleRight),label:Text('NEXT'),backgroundColor: currentComplete?Colors.green:Colors.grey,),)
      ],*/
      backgroundColor: Colors.black,

        body:Stack(
        children: <Widget>[
      PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: pgController,
      onPageChanged: (page) {
    print(primeMus+'{{');
    setState(() {
      if(page==0)
        {
          if(primeMus.isEmpty)
          {
            showInSnackBar('• Select MAIN Muscle');
            setState(() {
              currentComplete=false;
            });
          }
          else{
            print("Here");

            setState(() {
              currentComplete=true;
            });

          }

        }
     /*  else if(page==1)
      {
        if(secMus.isEmpty)
        {
          showInSnackBar('Select SUB Muscle');
          setState(() {
            currentComplete=false;
          });
        }
        else{
          print("Here");

          setState(() {
            currentComplete=true;
          });

        }

      }*/
      else if(page==2)
      {
        if(name_cont.text.isEmpty)
        { showInSnackBar('• Fill in NAME & ABOUT');
          setState(() {
            currentComplete=false;
          });
        }
        else{
          print("Here");

          setState(() {
            currentComplete=true;
          });

        }

      }

      else if(page==3)
      {
        if(level.isEmpty)
        { showInSnackBar('• Pick a LEVEL');
        setState(() {
          currentComplete=false;
        });
        }
        else{
          print("Here");

          setState(() {
            currentComplete=true;
          });

        }

      }
      else if(page==4)
      {

          print("Here");

          setState(() {
            currentComplete=true;
          });



      }



      setState(() {
          completedstep=page;

        });
      });},
      itemBuilder: (context, index) {
        return new Padding(
            padding: const EdgeInsets.all(2.0),
        child:pages()[index]);
      },
      itemCount: pages().length,
    ),
      new Padding(
        padding: const EdgeInsets.all(20.0),
          child:Align(alignment: Alignment.bottomCenter,child: gif||img?new Container():Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
           completedstep!=0? Align(alignment: Alignment.bottomLeft,child: FloatingActionButton.extended(onPressed:(){pgController.jumpToPage(completedstep-1);},icon: new Icon(FontAwesomeIcons.angleDoubleLeft),label:Text(prevPage),backgroundColor: prevComplete?Colors.teal:Colors.red,),):new Container(),
        Align(alignment: Alignment.bottomRight,child: FloatingActionButton.extended(onPressed:(){

          pgController.jumpToPage(completedstep+1);},icon: new Icon(FontAwesomeIcons.angleDoubleRight),label:Text('NEXT'),backgroundColor: currentComplete?Colors.green:Colors.grey,),)

        ],
      ),
    )
      )])
    );
    // TODO: implement build
  }
  bool img=false,gif=false;
  String url='';
  Widget gifPick()
  {
    return Card(
      child: Stack(
        children: <Widget>[
         new Center(child: CircularProgressIndicator()),
          Center(child:Container(width:400.0,height:400.0, child: FadeInImage(image: FileImage(new File(url)),fit: BoxFit.contain,placeholder: AssetImage('blank.png'),)),),
          Align(alignment: Alignment.topCenter,child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: <Widget>[FloatingActionButton.extended(onPressed:(){setState((){gif=false;img=false;url='';donePick=false;});},icon: Icon(Icons.cached),label: Text('CHANGE'),backgroundColor: Colors.red,),FloatingActionButton.extended(icon: Icon(Icons.check),backgroundColor:Colors.green,label: Text('DONE'),onPressed: (){setState(() {
  donePick=true;
  gif=false;
  img=false;
          });},),],)),

        ],
      )

    );
  }
  Widget imgPick()
  {
    return Card(
        child: Stack(
          children: <Widget>[
            new Center(child: CircularProgressIndicator()),
            Center(child: FadeInImage(image: FileImage(new File(url)),fit: BoxFit.contain,placeholder: AssetImage('blank.png'),),),
            Align(alignment: Alignment.topCenter,child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: <Widget>[FloatingActionButton.extended(onPressed:(){setState((){gif=false;img=false;url='';donePick=false;});},icon: Icon(Icons.cached),label: Text('CHANGE'),backgroundColor: Colors.red,),FloatingActionButton.extended(icon: Icon(Icons.check),backgroundColor:Colors.green,label: Text('DONE'),onPressed: (){setState(() {
              donePick=true;
              gif=false;
              img=false;
            });},),],)),

          ],
        )

    );
  }

  Widget imgDisplay()
  {
    return Card(
        child: Stack(
          children: <Widget>[
           // new Center(child: CircularProgressIndicator()),
            Center(child: FadeInImage(image: FileImage(new File(url)),fit: BoxFit.contain,placeholder: AssetImage('blank.png'),),),
            Align(alignment: Alignment.topCenter,child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: <Widget>[FloatingActionButton.extended(onPressed:(){setState((){gif=false;img=false;url='';donePick=false;});},icon: Icon(Icons.cached),label: Text('CHANGE'),backgroundColor: Colors.red,),],)),

          ],
        )

    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      url = image.path;

    });
  }
bool donePick=false;
  Widget image()
  {

    return Card(
      child:url.isNotEmpty&&donePick ? imgDisplay():gif?gifPick():img?imgPick():new Column(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: <Widget>[
        Expanded(child: new InkWell(
          onTap:url.isNotEmpty&&donePick?(){}:(){
              getImage();
              setState((){gif=false;img=true;});


          },
      child:Container(
        height: 290.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey,width: 5.0),
              borderRadius: BorderRadius.circular(5.0)
          ),
          child: new Center(child: Icon(Icons.add_a_photo,color: Colors.grey,size: 60.0,)),
        ))),
        Expanded(child: InkWell(
            onTap:(){
              getImage();
              setState((){gif=true;img=false;});

            },
            child: Container(
            height: 290.0,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black45,width: 5.0),
            borderRadius: BorderRadius.circular(5.0)
          ),
          child: new Center(child: Text('GIF',style:TextStyle(color: Colors.black45,fontSize: 40.0,)),
        ))))
      ],)

    );
  }
  Widget genrateBluredImage(String ic_url) {
    return new Container(

      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage(ic_url),
          fit: BoxFit.cover,
        ),
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }


  Widget completed()
  {

    final TextStyle mainHeading=TextStyle(fontFamily: 'Lobster',color: Colors.black,fontSize: 32.0);
    final TextStyle bodyStyle=TextStyle(color: Colors.black87,fontSize: 14.0);

    Widget muscles=Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
    Row(

        children:<Widget>[
      ImageIconsData.getIconbykeyword(primeMus),
      ImageIconsData.getIconbykeyword(secMus),]),
      primeMus.isEmpty ? new IconButton(icon: Icon(Icons.check,color:Colors.green),tooltip: 'Completed: [ • $primeMus • $secMus]',): new IconButton(icon: Icon(Icons.close,color:Colors.red),tooltip: 'Not Completed',)
    ]);

    Widget img=Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
               Card(child: Container(height: 200.0,width: 200.0,child: Center(child: url.isEmpty ? Icon(Icons.close):FadeInImage(image: FileImage(File(url)),placeholder: AssetImage('big_circleLoader.gif'),)),),),
           new IconButton(icon: Icon(Icons.check,color:Colors.green),tooltip: 'Completed: [ ${url.isEmpty ? 'No Image':'Image Selected'}] ',)
        ]);

    Widget name=
    Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
         new Center(child: Text(name_cont.text.isNotEmpty?name_cont.text:'NONE',style:mainHeading)),
         name_cont.text.isNotEmpty ? new IconButton(icon: Icon(Icons.check,color:Colors.green),tooltip: 'Completed: [ • ${name_cont.text} m•]',): new IconButton(icon: Icon(Icons.close,color:Colors.red),tooltip: 'Not Completed',)
        ]);

    Widget description=
/*
       ExpansionTile(
         key: Key(''),
         title:  Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children:<Widget>[*/
               Text('Description');
            // desc_cont.text.isEmpty ? new IconButton(icon: Icon(Icons.check,color:Colors.green),tooltip: 'Completed: [ • ${name_cont.text} m•]',): new IconButton(icon: Icon(Icons.close,color:Colors.red),tooltip: 'Not Completed',)
  /*           ]),
         children: <Widget>[
           Text(desc,style: bodyStyle,)
         ],
       );*/
    Widget lvl=Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
         Flame(level),
           level.isEmpty ? new IconButton(icon: Icon(Icons.check,color:Colors.green),tooltip: 'Completed: [ • $level•]',): new IconButton(icon: Icon(Icons.close,color:Colors.red),tooltip: 'Not Completed',)
        ]);

         Widget tip=
         Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children:<Widget>[
             /*  new FloatingActionButton(onPressed:(){
                 dialogBox(context,'Reccomendations: \n${reccomendation.text}\n • Sets: ${sets.text}\n • Reps: ${reps.text}\n • Weight: ${weight.text}', 'Tips & Recomendation');
               },child: Icon(Icons.wb_incandescent,color: Colors.midnightTextPrimary,),backgroundColor: Colors.mainscreenDark,mini: true,),
            */ ]);

         return Card(
           color: Colors.white.withOpacity(0.9),
           child: Padding(padding:  const EdgeInsets.all(20.0),child:
           Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
              Padding(padding: const EdgeInsets.all(10.0),child:muscles),
               new Center(child: img,),
               name,
              description,
             //lvl
             /* new Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   lvl,
                   tip
                 ],
               )*/
             ],
           )
           ),
         );



  }

  Future<Null> dialogBox(context,String msg,String title) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Bio'),
            content: new Text(
             msg,
            ),
          );
        });
  }

}
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

