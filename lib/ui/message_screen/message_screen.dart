import 'dart:async';

import 'package:flutter/material.dart';
import '../../utils/comet_chat.dart';
import 'dart:convert';

class MessageScreen extends StatefulWidget {
  final String UID;

  MessageScreen(this.UID);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final CometChat _cometChat = CometChat();
  final List<String> _messages = [];
  String _currentMessage;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _cometChat.initMethodChannel();
    _cometChat.initEventChannel();
    _cometChat.joinGroup().whenComplete(() {
      _cometChat.stream.receiveBroadcastStream().listen((value) {
        setState(() {
          _messages.add(value);
        });
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 500),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("Chat Room"),
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              messageList(),
              messageInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded messageList() {
    return Expanded(
      flex: 2,
      child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          controller: _controller,
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            return buildTile(_messages[index]);
          }),
    );
  }

  Padding messageInputArea() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: TextField(
              controller: _textController,
              onChanged: (value) {
                _currentMessage = value;
              },
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: "Enter Message",
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            flex: 1,
            child: RaisedButton(
              onPressed: () {
                _textController.clear();
                _cometChat.sendMessage(userMessage: _currentMessage);
                var data = {
                  'Message': _currentMessage,
                  'SenderUID': widget.UID
                };
                String result = json.encode(data);
                setState(() {
                  _messages.add(result);
                });
              },
              child: Text("Send"),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTile(String data) {
    var result = json.decode(data);
    print(result['SenderUID']);
    if (result['SenderUID'] == widget.UID) {
      //Own message
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Container(),
            ),
            Flexible(
              child: Card(
                elevation: 5.0,
                color: Colors.amberAccent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    result['Message'],
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
            CircleAvatar(
              backgroundImage: AssetImage('images/${widget.UID}.png'),
              backgroundColor: Colors.white,
            ),
          ],
        ),
      );
    } else {
      //Other's message
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(
                  'images/${widget.UID == 'batman' ? 'superman' : 'batman'}.png'),
              backgroundColor: Colors.white,
            ),
            Flexible(
              child: Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    result['Message'],
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(),
            ),
          ],
        ),
      );
    }
  }
}
