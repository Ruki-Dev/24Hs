import 'package:twenty_four_hours/Gym/Models/VideoPlaylist.dart';
import 'package:twenty_four_hours/Gym/Models/Videos.dart';

class Cinema {
  List<Videos> vlogs = new List<Videos>();
  List<Videos> workoutVids = new List<Videos>();
  List<Videos> mealPreps = new List<Videos>();
  List<VideoPlaylist> playlists = new List<VideoPlaylist>();

  Cinema([this.vlogs, this.workoutVids, this.mealPreps, this.playlists]);

  @override
  String toString() {
    return 'Cinema{vlogs: $vlogs, workoutVids: $workoutVids, mealPreps: $mealPreps, playlists: $playlists}';
  }
}
