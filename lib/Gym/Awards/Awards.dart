import 'package:twenty_four_hours/Gym/Models/Award.dart';

class Awards {
  /** All Gold Awards must be created here in this format to add a new silver Award
      Go to the line begore ...];
      Add in this template
      new GoldAward(
      ""//name
      ""//description
      4//id: id is the position of the Award Added
      false//Achieved: leave this always false
      ),
   **/
  List<GoldAward> goldAwards() {
    return [
      new GoldAward("Welcome Rookie", "Finish A Full Workout", 1, false),
      new GoldAward(
          "Just Getting Warmed Up", "Finish 10 Full Workout", 2, false),
      new GoldAward("Child's Play", "Finish 20 Full Workout", 4, false),
      new GoldAward("50th Milestone", "Finish 50 Full Workout", 5, false),
      //TODO:ADD More Awrds
    ];
  }

  /** All Silver Awards must be created here in this format to add a new silver Award
      Go to the line begore ...];
      Add in this template
      new SilverAward(
      ""//name
      ""//description
      4//id: id is the position of the Award Added
      false//Achieved: leave this always false
      ),
   **/
  List<SilverAward> siverAwards() {
    return [
      new SilverAward("Piece of Cake", "complete 10 Exercises", 1, false),
      new SilverAward("Any one can do this", "Complete 30 Exercises", 2, false),
      new SilverAward("Child's Play", "Finish 20 Full Workout", 3, false),
      //TODO:ADD More Awrds
    ];
  }

  /** All Bronze Awards must be created here in this format to add a new silver Award
      Go to the line begore ...];
      Add in this template
      new BronzeAward(
      ""//name
      ""//description
      4//id: id is the position of the Award Added
      false//Achieved: leave this always false
      ),
   **/
  List<BronzeAward> bronzeAward() {
    return [
      new BronzeAward("Piece of Cake", "complete 10 Exercises", 1, false),
      new BronzeAward("Any one can do this", "Complete 30 Exercises", 2, false),
      new BronzeAward("Child's Play", "Finish 20 Full Workout", 4, false),
    ];
  }
}
