import 'package:flutter/material.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';

class ChatPage extends StatelessWidget {
  final Profile profile;

  ChatPage({this.profile});

  @override
  Widget build(BuildContext context) {
    return Chat();
  }
}

class Chat extends StatefulWidget {
  final String title;

  Chat({Key key, this.title}) : super(key: key);

  ChatState createState() => new ChatState();
}

class ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    // TODO: Build HERE
    return Center(
      child: Text('Chat', style: TextStyle(fontSize: 50.0)),
    );
  }
}
