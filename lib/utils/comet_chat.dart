import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:meta/meta.dart';

class CometChat {
  MethodChannel _platform;
  EventChannel _stream;

  EventChannel get stream => _stream;

  void initMethodChannel(){
    _platform = const MethodChannel('com.sagar.gossip/initialize');
  }

  void initEventChannel(){
    _stream = const EventChannel('com.sagar.gossip/message');
  }

  //Method to initialize the CometChat SDK
  Future<String> init() async {
    String isInitialized = "Not Initialized";
    try {
      final bool result =
          await _platform.invokeMethod('isCometChatInitialized');
      isInitialized = "Comet was initialized successfully $result";
    } on PlatformException catch (e) {
      isInitialized = e.message;
    }
    return isInitialized;
  }

  //Login a user using API_KEY and UID of the user
  Future<String> login({@required String uid, @required String apiKey}) async {
    String status = "";
    try {
      final String result = await _platform
          .invokeMethod('loginUser', {"UID": uid, "API_KEY": apiKey});
      Map finalResult = json.decode(result);
      if (finalResult['RESULT']) {
        status = "Logged in successfully";
      } else {
        status = "Login failed";
      }
    } on PlatformException catch (e) {
      print("Exception");
      status = e.message;
    }
    return status;
  }

  Future<String> joinGroup() async{
    String status = "";
    try{
      final bool result = await _platform.invokeMethod('joinGroup', {'GUID': 'dc_superheroes'});
      if(result){
        status = "Success";
      }else{
        status = "Failed";
      }
    }on PlatformException catch (e){
      status = e.message;
    }
    return status;
  }

  //Send message to the user
  Future<String> sendMessage({@required String userMessage}) async {
    String status = "";
    try {
      final bool result = await _platform.invokeMethod('sendMessage',
          {"ROOM_ID": 'dc_superheroes', "MESSAGE": "$userMessage"});
      if (result) {
        status = "Message send successfully";
      } else {
        status = "Message was not sent";
      }
    } on PlatformException catch (e) {
      status = e.message;
    }
    print(status);
    return status;
  }
}
