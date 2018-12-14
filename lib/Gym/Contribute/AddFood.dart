import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:twenty_four_hours/Gym/Models/Meal.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Widget_Assets/RadialSeekBar.dart';

class AddFood extends StatefulWidget {
  AddFood({this.profile});

  final Profile profile;

  AddFoodState createState() => AddFoodState();
}

class AddFoodState extends State<AddFood> {
  Meal meal;
  String _name = '';
  int kcal = 0;
  Nutrients nutrients = new Nutrients();
  List<String> incredients = List<String>();
  List<String> recipie = List<String>();
  String prep = '';
  String imgurl = '';
  int completedStep = 0;
  bool prevComplete = false,
      currentComplete = false;
  TextEditingController name_cont = TextEditingController();
  TextEditingController prep_cont = TextEditingController();

  PageController pgController = new PageController(initialPage: 0);

  List<Widget> pages() {
    List<Widget>steps = [
      namePrep(),
      contents(),
      image(),
      types(),
      //completed()
    ];
    return steps;
  }
  String getValue(num val) {
    return new NumberFormat.compact().format(val);
  }
  double _seekPercent=0.0;
  TextEditingController nameCont=new TextEditingController();
  TextEditingController prepCont=new TextEditingController();
  List<TextEditingController> ingrigients=[TextEditingController()];
  int count = 1;
  Widget namePrep()
  {
    TextStyle mainStyle=TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: "Jua",
        fontSize:14.0,
        color:Colors.black
    );
    Widget header=TextField(
      controller: nameCont,

      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Tap to Enter Food Name",
        hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Galada",
            fontSize:18.0,
            color:Colors.grey
        )
      ),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: "Galada",
        fontSize:18.0,
        color:Colors.black
      )
    );

    List<bool> cancels=[];
    for(int i=0;i<15;i++)
      cancels.add(false);
    List<Widget> steps = [];
    steps=new List.generate(count, (int i)=>new InputWidget(i,mainStyle,cancel:cancels[i],onCancel: (){setState(() {
    /*  List<Widget> temp=[];
      print("\n${steps.length}\n");
      steps.removeAt(i);
      print("\n${steps.length}\n");
      //ingrigients.removeAt(i);
      for(Widget w in steps)
        {
          temp.add(w);
        }
        steps=temp;
      print("\n${steps.length}\n");*/
      setState(() {
        print(cancels[i]);
        print(cancels);
        if(cancels[i]==true)
        {
          setState(() {
            cancels[i]=false;
          });
          cancels[i]=false;
        }else{

          setState(() {
            cancels[i]=true;
          });
          cancels[i]=true;
          print(cancels);
        }
      });



    });}));



   /* List<TextField> steps=[TextField(
      style: mainStyle,
      controller: ingrigients[0],
      decoration: InputDecoration(
        //border:InputBorder.none,
        hintText: "Enter An Incredient",
        prefixText: "1. ",
      )
    )];*/
    RaisedButton addButton=RaisedButton(
      child: Text("New Ingredient"),
      onPressed: steps.length<15?(){
        setState(() {
         // showInSnackBar("New Ingredient ${steps.length}");
          /*ingrigients.add(new TextEditingController());
          steps.add(
              new TextField(
                  style: mainStyle,
                 // controller: ingrigients[steps.length],
                  decoration: InputDecoration(
                    //border:InputBorder.none,
                      hintText: "Enter An Ingredient",
                      prefixText: "${steps.length}. ",
                      suffixIcon: IconButton(icon:Icon(Icons.close),onPressed: (){setState(() {
                        steps.removeAt(steps.length);
                        ingrigients.removeAt(steps.length);
                      });},)
                  )
              )
          );*/
          cancels.add(false);
          count=count+1;

          showInSnackBar("Added ${steps.length}");
        });
      }:(){},
    );


    TextFormField prep=new TextFormField(
      controller: prepCont,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Meal Peparation',
        helperText: 'Steps to reproducing the meal',
        labelText: 'Preparation',
      ),
      maxLines: 15,
    );
    return Card(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Center(
              child: Padding(padding: const EdgeInsets.all(20.0),child:header)
            ),
            Divider(color:Colors.black87),
            Center(child: Text("Ingredients",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Galada",
                fontSize:18.0,
                color:Colors.black
            ),),),
            Padding(padding: const EdgeInsets.all(12.0),child:Column(children:steps)),
            Center(child:addButton),
            Divider(color: Colors.black87,),
            Padding(padding: const EdgeInsets.all(12.0),child:prep),




          ],
        )
    );
  }

  Widget contents() {
    Widget kcalText= Column(
      children: <Widget>[
        Text(getValue(_seekPercent),style: TextStyle(color: Colors.white70,fontFamily: 'Chicle',fontSize: 30.0),),
        Text("Kcal",style: TextStyle(fontSize: 10.0),)
      ],
    );
    Widget kcal= RadialSeekBar(

      progress: 1.0,

      seekPercent: _seekPercent,

      onSeekRequested: (double seekPercent) {

        setState(() => _seekPercent = seekPercent);



       // final seekMillis = (player.audioLength.inMilliseconds * seekPercent).round();

       // player.seek(new Duration(milliseconds: seekMillis));

      },

      child: new Container(

        //color: accentColor,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal,
              Colors.tealAccent,
              Colors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),

        child: kcalText
      ),

    );
    return new Card(
       child: ListView(
         shrinkWrap: true,
         children: <Widget>[
           kcal,
           Container(
             decoration: BoxDecoration(border: Border.all(width: 3.0,color:Colors.grey),
             borderRadius: BorderRadius.circular(5.0)
             ),
             padding: const EdgeInsets.all(25.0),
             child: Column(
               children:<Widget>[
                 Padding(padding: const EdgeInsets.all(10.0),child: Center(child: Text("Nutrition",style:TextStyle(fontFamily: "chicle",color: Colors.black,fontSize: 22.0)))),
                 nutrition(),

               ])
           ),


         ],
       )
      );
  }
  Widget vitamins(String type,TextEditingController controller)
  {
    return Container(
        child: Column(
          children: <Widget>[
            Text(type,style: TextStyle(color: Colors.white70,fontSize: 18.0),),
            TextField(controller:controller,decoration: InputDecoration(border: InputBorder.none,hintText: "- -",),)
          ],
        )
    );
  }
Widget nutrientBox(String name,double val,TextEditingController controller,Color color)
{
  return Container(
    padding: const EdgeInsets.all(20.0),
    color: color,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[

        Text(name,style: TextStyle(color: Colors.white70,fontSize: 18.0),),
        TextField(controller:controller,keyboardType: TextInputType.number,decoration: InputDecoration(border: InputBorder.none,hintText: "- -",),)
      ],
    )
  );
}
  List<TextEditingController> controllers=new List<TextEditingController>();
  Widget nutrition() {
    for(int i=0;i<15;i++){
      controllers.add(new TextEditingController());
      /// 0-Carbs
      /// 1-Protein
      /// 2-Fats
      /// 3-Energy
      /// 4-calcium
      /// 5-sodium
      /// 6-potasium
      /// 7-fibre
      /// 8-salt
      /// 9-water
      /// 10+ -vitamins;
    }
    return new Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: <Widget>[
          nutrientBox("Carbourhydrates", 0.0, controllers[0],Colors.yellow.shade200),
          nutrientBox("Protein", 0.0, controllers[1],Colors.orange.withRed(222)),
          nutrientBox("Fats", 0.0, controllers[2],Colors.yellow),
          nutrientBox("Energy", 0.0, controllers[3],Colors.red),
          nutrientBox("Calcium", 0.0, controllers[4],Colors.green.shade300),
          nutrientBox("Sodium", 0.0, controllers[5],Colors.green),
          nutrientBox("Potasium", 0.0, controllers[6],Colors.white12),
          nutrientBox("Fibre", 0.0, controllers[7],Colors.teal),
          nutrientBox("Salts", 0.0, controllers[8],Colors.grey),
          nutrientBox("Water", 0.0, controllers[9],Colors.cyan),
          vitamins("Vitaim:", controllers[10]),
          vitamins("Vitaim:", controllers[11]),
          vitamins("Vitaim:", controllers[12]),
          vitamins("Vitaim:", controllers[13]),
          vitamins("Vitaim:", controllers[14]),

        ]);
  }

  Widget image() {

  }

  Widget types() {

  }
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        key: _scaffoldKey,
        appBar: AppBar(backgroundColor: Colors.transparent,
          title: Text('${completedStep + 1}/4 Steps'),
          actions: <Widget>[IconButton(icon: currentComplete
              ? Icon(
            FontAwesomeIcons.angleDoubleRight, color: Colors.lightGreenAccent,)
              : Icon(Icons.info, color: Colors.grey,))
          ],),
        // floatingActionButton: FloatingActionButton.extended(onPressed:(){pgController.jumpToPage(completedstep+1);},icon: new Icon(FontAwesomeIcons.angleDoubleRight),label:Text('NEXT'),backgroundColor: currentComplete?Colors.green:Colors.grey,),
        /*  persistentFooterButtons: <Widget>[
        completedstep!=1? FloatingActionButton.extended(onPressed:(){pgController.jumpToPage(completedstep-1);},icon: new Icon(FontAwesomeIcons.angleDoubleLeft),label:Text(prevPage),backgroundColor: prevComplete?Colors.teal:Colors.red,):FloatingActionButton(child: Icon(Icons.close),backgroundColor: Colors.grey,)
       //completedstep!=1? Align(alignment: Alignment.bottomLeft,child: FloatingActionButton.extended(onPressed:(){pgController.jumpToPage(completedstep-1);},icon: new Icon(FontAwesomeIcons.angleDoubleLeft),label:Text(prevPage),backgroundColor: prevComplete?Colors.teal:Colors.red,),):new Container(),
      //  Align(alignment: Alignment.bottomRight,child: FloatingActionButton.extended(onPressed:(){pgController.jumpToPage(completedstep+1);},icon: new Icon(FontAwesomeIcons.angleDoubleRight),label:Text('NEXT'),backgroundColor: currentComplete?Colors.green:Colors.grey,),)
      ],*/
        backgroundColor: Colors.black,

        body: Stack(
            children: <Widget>[
              PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: pgController,
                onPageChanged: (page) {
                  setState(() {
                    if (page == 0) {
                      if (name_cont.text.isEmpty) {
                        showInSnackBar('• Name of FOOD');
                        setState(() {
                          currentComplete = false;
                        });
                      }
                      else {
                        print("Here");

                        setState(() {
                          currentComplete = true;
                        });
                      }
                    };
                    setState(() {
                      completedStep = page;
                    });
                  });
                },
                itemBuilder: (context, index) {
                  return new Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: pages()[index]);
                },
                itemCount: pages().length,
              ),
              new Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(alignment: Alignment.bottomCenter,
                    child: gif || img ? new Container() : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        completedStep != 0 ? Align(
                          alignment: Alignment.bottomLeft,
                          child: FloatingActionButton.extended(onPressed: () {
                            pgController.jumpToPage(completedStep - 1);
                          },
                            icon: new Icon(FontAwesomeIcons.angleDoubleLeft),
                            label: Text(''),
                            backgroundColor: prevComplete ? Colors.teal : Colors
                                .red,),) : new Container(),
                        Align(alignment: Alignment.bottomRight,
                          child: FloatingActionButton.extended(onPressed: () {
                            pgController.jumpToPage(completedStep + 1);
                          },
                            icon: new Icon(FontAwesomeIcons.angleDoubleRight),
                            label: Text('NEXT'),
                            backgroundColor: currentComplete
                                ? Colors.green
                                : Colors.grey,),)

                      ],
                    ),
                  )
              )
            ])
    );
    // TODO: implement build
  }

  bool img = false,
      gif = false;
  String url = '';


  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

}

class InputWidget extends StatelessWidget {

  final int index;
  final TextStyle style;
  final VoidCallback onCancel;final bool cancel;
  TextEditingController controller =TextEditingController();
  InputWidget(this.index,this.style,{this.cancel=false,this.onCancel});

  @override
  Widget build(BuildContext context) {
    return  new TextField(
        style: style,
       enabled: !cancel,
        //controller: ingrigients[steps.length],
        decoration: InputDecoration(
         // border:InputBorder.none,
            fillColor: Colors.red,
            filled: cancel,
            hintText: "Enter An Ingredient",
            prefixText: "${index+1}. ",
            suffixIcon: IconButton(icon:Icon(Icons.close),onPressed:onCancel)
        )
    );
  }
  String getText()
  {
    return controller.text;
  }
}