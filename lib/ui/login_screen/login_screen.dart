import 'package:flutter/material.dart';
import '../../utils/comet_chat.dart';
import '../message_screen/message_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const API_KEY = "09598c4d81e1fd4eee40486d7cb17f69a69846eb";
  CometChat _cometChat = CometChat();
  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    _cometChat.initMethodChannel();
    _cometChat.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("Gossip"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            logo(),
            SizedBox(height: 30.0),
            Text(
              "Login as..",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28.0,
                fontFamily: "Roboto",
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () => loginUser("batman"),
                  child: batman(),
                ),
                GestureDetector(
                  onTap: () => loginUser("superman"),
                  child: superman(),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                showProgress(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card superman() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            userImage('images/superman.png'),
            SizedBox(height: 5.0),
            Text(
              'Superman',
            ),
          ],
        ),
      ),
      elevation: 5.0,
      shape: CircleBorder(),
    );
  }

  Card batman() {
    return Card(
      child: Container(
        child: Column(
          children: <Widget>[
            userImage('images/batman.png'),
            SizedBox(height: 5.0),
            Text(
              'Batman',
            ),
          ],
        ),
        padding: EdgeInsets.all(25.0),
      ),
      elevation: 5.0,
      shape: CircleBorder(),
    );
  }

  loginUser(String UID) {
    if(!_showProgress) {
      _cometChat.login(uid: UID, apiKey: API_KEY).then((value) {
        setState(() {
          _showProgress = false;
        });
        final page = MessageScreen(UID);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> page));
      }).catchError((error) {
        print(error.toString());
        setState(() {
          _showProgress = false;
        });
      });
    }
    setState(() {
      _showProgress = true;
    });
  }

  Widget userImage(String imagePath) {
    return Image(
      image: AssetImage(imagePath),
      width: 60.0,
      height: 60.0,
    );
  }

  Widget logo() {
    return Image(
      image: AssetImage('images/chat.png'),
      height: 100.0,
      width: 100.0,
    );
  }

  Widget showProgress() {
    if(_showProgress){
      return CircularProgressIndicator(backgroundColor: Colors.white);
    }else{
      return SizedBox(height: 35.0);
    }
  }
}
