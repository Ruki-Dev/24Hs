import 'package:twenty_four_hours/Authentication/Auth_Model/Register.dart';
import 'package:twenty_four_hours/Gym/Models/Award.dart';
import 'package:twenty_four_hours/Gym/Models/Cinema.dart';
import 'package:twenty_four_hours/Gym/Models/Follows.dart';
import 'package:twenty_four_hours/Gym/Models/Gallery.dart';
import 'package:twenty_four_hours/Gym/Models/Workout.dart';
import 'package:twenty_four_hours/Gym/Models/WorkoutPlans.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/MealPlans.dart';
import 'package:twenty_four_hours/Main/Friends.dart';

class Profile {
  Register _user = new Register();
  Follows _follow = new Follows();
  String _UID = '';
  Gallery gallery = new Gallery();
  Award _awards = new Award();
  Friends _friends;
  String _bio = 'Hey There!, Welcome to MyFit Profile';
  List<Gallery> savedPictures;
  List<Workout>savedWorkouts=new List<Workout>();
  List<WorkoutPlan>savedWorkoutPlans;
  List<MealPlans>savedMealPlans;
  List<Workout>completedWorkouts;
  List<WorkoutPlan>completedWorkoutPlans;
  WorkoutPlan currentWorkoutPlan;
  WoroutStats workoutStats;



  Cinema cinema;

  Profile(
      [this._user,
      this._UID,
      this._follow,
      this._awards,
      this._bio,
      this.gallery,
      this._friends,
      this.cinema,
      this.savedWorkouts]){savedWorkouts=new List<Workout>();}

  Award get awards => _awards;

  set awards(Award value) {
    _awards = value;
  }

  Friends get friends => _friends;

  set friends(Friends value) {
    _friends = value;
  }

  String get bio => _bio;

  set bio(String value) {
    _bio = value;
  }

  Follows get follow => _follow;

  set follow(Follows value) {
    _follow = value;
  }

  String get UID => _UID;

  set UID(String value) {
    _UID = value;
  }

  Register get user => _user;

  set user(Register value) {
    _user = value;
  }

  @override
  String toString() {
    return 'Profile{_user: $_user, _follow: $_follow, _UID: $_UID, gallery: $gallery, _awards: $_awards, _friends: $_friends, _bio: $_bio, savedPictures: $savedPictures}';
  }
}
class WoroutStats{
  double averageKcal;
  double currentWeight;
  String favouriteMuscle;
  int strengthLvl;

  WoroutStats({this.averageKcal=0.0, this.currentWeight=0.0, this.favouriteMuscle='',this.strengthLvl=0});


}