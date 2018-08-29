import 'package:twenty_four_hours/Authentication/Auth_Model/Register.dart';
import 'package:twenty_four_hours/Gym/Models/Award.dart';
import 'package:twenty_four_hours/Gym/Models/Cinema.dart';
import 'package:twenty_four_hours/Gym/Models/Comments.dart';
import 'package:twenty_four_hours/Gym/Models/Follows.dart';
import 'package:twenty_four_hours/Gym/Models/Gallery.dart';
import 'package:twenty_four_hours/Gym/Models/Picture.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Gym/Models/Videos.dart';
import 'package:twenty_four_hours/Main/Friends.dart';

class CreateAccounts {
  Register ol, jc, anika, teyana, tony;
  String olID, jcID, anikaID, teyanaID, TonyID;
  Award olAward, jcAward, anikaAward, teyanaAWard, TonyIAward;

  CreateAccounts() {
    ol = new Register(
        "Ollie",
        'olamidepeters@gmail.com',
        'ollie',
        'peters',
        '30/11/1998',
        DateTime.now(),
        'Male',
        089603367,
        'https://firebasestorage.googleapis.com/v0/b/hours-db878.appspot.com/o/ZdnBGWX4xrM1sGJRhGJvUMlFzCE2%2FProfile%2Fprofile_pic.png?alt=media&token=91a14d1f-057c-494b-8839-28200e5986f5',
        ['Basketball', 'Music', 'Fitness', 'Codding', 'Movies']);

    olID = 'ewuhyefwhyef8AWE6qw';
    olAward = new Award(
      [
        new GoldAward("Welcome Rookie", "Finish A Full Workout", 1, false),
        new GoldAward(
            "Just Getting Warmed Up", "Finish 10 Full Workout", 2, false),
      ],
      [
        new SilverAward("Piece of Cake", "complete 10 Exercises", 1, false),
      ],
      [
        new BronzeAward("Piece of Cake", "complete 10 Exercises", 1, false),
      ],
    );

    jc = new Register(
        "Jcole",
        'jamainecole@gmail.com',
        'Jamaine',
        'Cole',
        '22/04/1985',
        DateTime.now(),
        'Male',
        089603367,
        'https://cdn-images-1.medium.com/max/1600/1*noV7xapzXHhAOws6VcLswA.png',
        // data-src="https://cdn-images-1.medium.com/max/1600/1*noV7xapzXHhAOws6VcLswA.png',
        ['Music', 'Basketball', 'Concerts', 'Travel']);
    jcID = 'tfr4ew364s64swq5wq3';
    jcAward = new Award(
      [
        new GoldAward("Welcome Rookie", "Finish A Full Workout", 1, false),
        new GoldAward(
            "Just Getting Warmed Up", "Finish 10 Full Workout", 2, false),
        new GoldAward("Child's Play", "Finish 20 Full Workout", 4, false),
        new GoldAward("50th Milestone", "Finish 50 Full Workout", 5, false),
      ],
      [
        new SilverAward("Piece of Cake", "complete 10 Exercises", 1, false),
        new SilverAward(
            "Any one can do this", "Complete 30 Exercises", 2, false),
        new SilverAward("Child's Play", "Finish 20 Full Workout", 3, false),
      ],
      [
        new BronzeAward("Piece of Cake", "complete 10 Exercises", 1, false),
        new BronzeAward(
            "Any one can do this", "Complete 30 Exercises", 2, false),
        new BronzeAward("Child's Play", "Finish 20 Full Workout", 4, false),
      ],
    );
    anika = new Register(
        "sugga",
        'AnikaLove@gmail.com',
        'Anika',
        'Love',
        '1/12/1990',
        DateTime.now(),
        'Female',
        089603367,
        'https://i.pinimg.com/originals/97/8c/c8/978cc8c8605e9a759cb801ed6d0cbf3d.jpg',
        ['Adult Modelling', 'Music', 'Art']);
    anikaID = 'gd28763r8743gydFGef8w';
    anikaAward = new Award(
      [
        new GoldAward("Welcome Rookie", "Finish A Full Workout", 1, false),
        new GoldAward(
            "Just Getting Warmed Up", "Finish 10 Full Workout", 2, false),
        new GoldAward("Child's Play", "Finish 20 Full Workout", 4, false),
        new GoldAward("50th Milestone", "Finish 50 Full Workout", 5, false),
      ],
      [
        new SilverAward("Piece of Cake", "complete 10 Exercises", 1, false),
        new SilverAward(
            "Any one can do this", "Complete 30 Exercises", 2, false),
        new SilverAward("Child's Play", "Finish 20 Full Workout", 3, false),
      ],
      [
        new BronzeAward("Piece of Cake", "complete 10 Exercises", 1, false),
        new BronzeAward(
            "Any one can do this", "Complete 30 Exercises", 2, false),
        new BronzeAward("Child's Play", "Finish 20 Full Workout", 4, false),
      ],
    );
    teyana = new Register(
        "TT",
        'TeyanaTaylor@gmail.com',
        'Teyanna',
        'Taylor',
        '12/11/1987',
        DateTime.now(),
        'Female',
        089603367,
        'http://thesource.com/wp-content/uploads/2018/07/teyana-taylor-tour-tgj-1.jpg',
        ['Dancing', 'Music', 'Hip-Hop'],
        'https://firebasestorage.googleapis.com/v0/b/hours-db878.appspot.com/o/24H_Videos%2FTeyana%20Taylor%20And%20Iman%20Shumpert%20Arguing.mp4?alt=media&token=8b0f044f-76fd-4300-951a-41f5be18d93c');
    teyanaAWard = new Award(
      [
        new GoldAward("Welcome Rookie", "Finish A Full Workout", 1, false),
        new GoldAward(
            "Just Getting Warmed Up", "Finish 10 Full Workout", 2, false),
        new GoldAward("Child's Play", "Finish 20 Full Workout", 4, false),
      ],
      [
        new SilverAward("Piece of Cake", "complete 10 Exercises", 1, false),
        new SilverAward("Child's Play", "Finish 20 Full Workout", 3, false),
      ],
      [
        new BronzeAward("Piece of Cake", "complete 10 Exercises", 1, false),
        new BronzeAward("Child's Play", "Finish 20 Full Workout", 4, false),
      ],
    );
    teyanaID = '3AgE6yf986fdg5fiygd';
    tony = new Register(
        "IRONMAN",
        'Tonystart@avengers.com',
        'Tony',
        'Stark',
        '1/30/1977',
        DateTime.now(),
        'Male',
        089603367,
        'https://aa1a5178aef33568e9c4-a77ea51e8d8892c1eb8348eb6b3663f6.ssl.cf5.rackcdn.com/p/full/e76994f4-177e-450e-9e77-4fae507708e7.jpg',
        ['Movies', 'Money', 'Adult Modeling', 'Parties']);
    TonyID = 'dsfugy3409f72r3rregh';
    TonyIAward = Award([], [], []);
  }

  Profile ollie() {
    return new Profile(
        ol,
        olID,
        new Follows(true, [jcole(), Teyana()], []),
        olAward,
        'Hey There! i\'m ${ol.first_name}, Welcome to MyFit Profile',
        new Gallery([
          new Picture(
              'https://wallpaperbrowse.com/media/images/soap-bubble-1958650_960_720.jpg',
              'Winter',
              ''),
          new Picture(
              'https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?auto=compress&amp;cs=tinysrgb&amp;h=350',
              'Islander',
              ''),
          new Picture(
              'https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?cs=srgb&amp;dl=sea-landscape-nature-248797.jpg&amp;fm=jpg',
              'Unknown',
              ''),
        ], 'My Stuff'),
        new Friends([jcole(), Teyana()], [], [], [], []));
  }

  Profile jcole() {
    return new Profile(
        jc,
        jcID,
        new Follows(true, [], []),
        jcAward,
        'Hey There! i\'m ${jc.first_name}, Welcome to MyFit Profile',
        new Gallery([
          new Picture(
              'https://wallpaperbrowse.com/media/images/soap-bubble-1958650_960_720.jpg',
              'Winter',
              ''),
          new Picture(
              'https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?auto=compress&amp;cs=tinysrgb&amp;h=350',
              'Islander',
              ''),
          new Picture(
              'https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?cs=srgb&amp;dl=sea-landscape-nature-248797.jpg&amp;fm=jpg',
              'Unknown',
              ''),
        ], 'My Stuff'),
        new Friends([], [], [], [], []));
  }

  Profile Anika() {
    return new Profile(
        anika,
        anikaID,
        new Follows(true, [ollie()], []),
        anikaAward,
        'Hey There! i\'m ${anika.first_name}, Welcome to MyFit Profile',
        new Gallery([
          new Picture(
              'https://wallpaperbrowse.com/media/images/soap-bubble-1958650_960_720.jpg',
              'Winter',
              ''),
          new Picture(
              'https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?auto=compress&amp;cs=tinysrgb&amp;h=350',
              'Islander',
              ''),
          new Picture(
              'https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?cs=srgb&amp;dl=sea-landscape-nature-248797.jpg&amp;fm=jpg',
              'Unknown',
              ''),
        ], 'My Stuff'),
        new Friends([], [], [], [], []));
  }

  Profile Teyana() {
    return new Profile(
        teyana,
        teyanaID,
        new Follows(true, [jcole()], []),
        teyanaAWard,
        'Hey There! i\'m ${teyana.first_name}, Welcome to MyFit Profile',
        new Gallery([
          new Picture(
              'https://wallpaperbrowse.com/media/images/soap-bubble-1958650_960_720.jpg',
              'Winter',
              '', [
            new Comments(jcole(), 'Damn i like that s***', [IronMan()])
          ], [
            jcole()
          ], [
            IronMan(),
            jcole()
          ]),
          new Picture(
              'https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?auto=compress&amp;cs=tinysrgb&amp;h=350',
              'Islander',
              ''),
          new Picture(
              'http://thesource.com/wp-content/uploads/2018/07/teyana-taylor-tour-tgj-1.jpg',
              'Modeling Time',
              '', [
            new Comments(IronMan(), 'You Are So Pretty ☺♥♥', [IronMan()])
          ], [
            IronMan()
          ], [
            IronMan()
          ]),
        ], 'My Stuff'),
        new Friends([], [], [], [], []),
        new Cinema(
            /*
      * String _title='';
   String _decription='';
   String _streamlink='';
   DateTime _dateCreated=DateTime.now();
   String _thumbnail='';
   int _rating=0;
   List<String> _tags=new List<String>();
   List<Profile>_upVotes=new List<Profile>();
   List<Comments>_comments=new List<Comments>();
   List<Profile>_viewedBy=new List<Profile>();
   List<MuscleGroup> _muscleTargets=new List<MuscleGroup>();

      * */
            [
              new Videos(
                jcole(),
                'Kanye West • Fade(ft. Teyana Taylor)',
                'I was shaking. I was on Twitter and Instagram, but my phone was shaking because my hand was shaking. I was so nervous because it was really a do-or-die moment. I’ve worked so hard and I didn’t know that that moment was going to be that huge because I didn’t have time to mentally prepare. But it was dope that I was able to really sit back and really take in the whole moment. It’s emotional because I’ve been in the industry for so long and I’ve never understood why certain things weren’t happening. And now I feel like my story, everything that I’ve been through, makes this moment so much more special. Though it took so long for this to happen, I don’t feel like it could’ve happened at a better time.',
                'https://firebasestorage.googleapis.com/v0/b/hours-db878.appspot.com/o/24H_Videos%2FKanye%20West%20-%20Fade%20(Explicit).mp4?alt=media&token=ef0775c8-afdf-4f70-97b6-15d2ae84ce28',
                'https://www.youtube.com/watch?v=IxGvm6btP1A',
                "https://static1.squarespace.com/static/56a5728269a91a8ab6110614/56a825145a5668d2c8a8940e/57c72aae2994ca8ea02351ed/1472700835593/Unknown-2.jpeg?format=1500w",
                DateTime.now(),
                ['Music', 'Hip-hop', 'work hard'],
              ),
              new Videos(
                jcole(),
                'Teyana Taylor • Rose in Harlem',
                'This is from my new album',
                'https://firebasestorage.googleapis.com/v0/b/hours-db878.appspot.com/o/24H_Videos%2FTeyana%20Taylor%20-%20Rose%20In%20Harlem%20(K.T.S.E.).mp4?alt=media&token=cea4360f-5237-4ede-a4b5-bb7687d05938',
                'https://www.youtube.com/watch?v=RWVHpvTGkXI',
                "https://images.genius.com/711aa3475002ea5b04a7d7fcefc670ed.1000x1000x1.jpg",
                DateTime.now(),
                ['Music', 'Hip-hop', 'work hard'],
              ),
              new Videos(
                IronMan(),
                'Teyana Taylor Opens Up About Why She Was Disappointed With Her Album Release',
                'I HATE PEOPLE',
                'https://r3---sn-ug5onuxaxjvh-3gge.googlevideo.com/videoplayback?pl=20&mn=sn-ug5onuxaxjvh-3gge%2Csn-ug5onuxaxjvh-n8vz&mm=31%2C29&source=youtube&fvip=3&dur=2256.282&initcwndbps=460000&mime=video%2Fmp4&ip=31.15.82.123&requiressl=yes&signature=82A9EBA79CAA137714063DFBF040B6052308B16B.7E60DDD6DE3F32CD95B6171897D9290219AE714C&expire=1533826400&mv=m&mt=1533804715&ms=au%2Crdu&id=o-APdhFRgMxSXbv3pTmKmBTlr3sNXbo-c1ABucWCJJCOnt&lmt=1531429059733869&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cexpire&ratebypass=yes&ipbits=0&key=yt6&c=WEB&itag=22&ei=AAFsW-jlEaLQ7gS5g7GYAQ&video_id=IkaKoOS7lFA&title=Teyana+Taylor+Opens+Up+About+Why+She+Was+Disappointed+With+Her+Album+Release',
                'https://www.youtube.com/watch?v=IkaKoOS7lFA&t=1920s',
                "https://i.ytimg.com/vi/IkaKoOS7lFA/maxresdefault.jpg",
                DateTime.now(),
                ['Music', 'Hip-hop', 'BACKLASH'],
              ),
            ]));
  }

  Profile IronMan() {
    return new Profile(tony, TonyID, new Follows(true, [], []), TonyIAward,
        'Hey There! i\'m ${tony.first_name}, Welcome to MyFit Profile');
  }
}
