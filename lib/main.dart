import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'ui/login_screen/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

//class MyHomePage extends StatefulWidget {
//  final String title;
//
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}

//class _MyHomePageState extends State<MyHomePage> {
//  static const platform = const MethodChannel('com.sagar.gossip/initialize');
//  static const stream = const EventChannel('com.sagar.gossip/message');
//
//  String _userMessage = "";
//
//  static const UID = "SUPERHERO1";
//  static const _receiverID = "SUPERHERO2";
//  static const API_KEY = "09598c4d81e1fd4eee40486d7cb17f69a69846eb";
//
//  @override
//  void initState() {
//    super.initState();
//    init().whenComplete(() {
//      login().whenComplete(() {
//        print("Logged in");
//      });
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          title: Text(widget.title),
//        ),
//        body: Center(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              TextField(
//                decoration: InputDecoration(
//                  hintText: "Enter Message",
//                ),
//                onChanged: (value) {
//                  _userMessage = value;
//                },
//              ),
//              Container(margin: EdgeInsets.all(8.0)),
//              StreamBuilder(
//                  stream: stream.receiveBroadcastStream(),
//                  builder: (BuildContext context, AsyncSnapshot snapshot) {
//                    if (snapshot.hasError) {
//                      return Text('Error ${snapshot.error.toString()}');
//                    } else if (snapshot.hasData) {
//                      return Text(snapshot.data.toString());
//                    }
//                    return Text('Incoming Messages');
//                  })
//            ],
//          ),
//        ),
//        floatingActionButton: FloatingActionButton(
//          onPressed: sendMessage,
//          tooltip: 'Send Message',
//          child: Icon(Icons.send),
//        ) // This trailing comma makes auto-formatting nicer for build methods.
//        );
//  }
//
//  //Method to initialize the CometChat SDK
//  Future<String> init() async {
//    String isInitialized = "Not Initialized";
//    try {
//      final bool result = await platform.invokeMethod('isCometChatInitialized');
//      isInitialized = "Comet was initialized successfully $result";
//    } on PlatformException catch (e) {
//      isInitialized = e.message;
//    }
//    return isInitialized;
//  }
//
//  //Login a user using API_KEY and UID of the user
//  Future<String> login() async {
//    String status = "";
//    try {
//      final String result = await platform
//          .invokeMethod('loginUser', {"UID": UID, "API_KEY": API_KEY});
//      Map finalResult = json.decode(result);
//      if (finalResult['RESULT']) {
//        status = "Logged in successfully";
//      } else {
//        status = "Login failed";
//      }
//    } on PlatformException catch (e) {
//      print("Exception");
//      status = e.message;
//    }
//    return status;
//  }
//
//  //Send message to the user
//  Future<String> sendMessage() async {
//    String status = "";
//    try {
//      final bool result = await platform.invokeMethod('sendMessage',
//          {"RECEIVER_ID": '$_receiverID', "MESSAGE": "$_userMessage"});
//      if (result) {
//        status = "Message send successfully";
//      } else {
//        status = "Message was not sent";
//      }
//    } on PlatformException catch (e) {
//      status = e.message;
//    }
//    print(status);
//    return status;
//  }
//}
