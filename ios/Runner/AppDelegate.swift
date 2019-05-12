import UIKit
import Flutter
import CometChatPro

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler, CometChatMessageDelegate {
    let APP_ID = "2417ac4b36c63d"
    private var eventSink: FlutterEventSink?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    //Channel to init, login and send messages
    let cometChatChannel = FlutterMethodChannel(name: "com.sagar.gossip/initialize",
                                              binaryMessenger: controller)
    
    //Channel to listen for incoming messages
    let streamChannel = FlutterEventChannel(name: "com.sagar.gossip/message", binaryMessenger: controller)
    streamChannel.setStreamHandler(self)
    
    //register appdelegate to receive text messages
    CometChat.messagedelegate = self
    
    
    cometChatChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch call.method{
            //initialize the CometChat SDK
        case "isCometChatInitialized":
            self.isCometChatInitialized(result: result)
            //login the user to CometChat
        case "loginUser":
            let args = call.arguments as! [String: String]
            if args.count == 2 {
             self.loginUser(result: result, uid: args["UID"]!, apiKey: args["API_KEY"]!)
            }else{
                result(FlutterError(code: "Error",message: "Args not passed",details: nil))
            }
            //Send messages to other CometChat user
        case "sendMessage":
            let args = call.arguments as! [String: String]
            if args.count == 2{
                self.sendMessage(result: result, receiverID: args["ROOM_ID"]!, text: args["MESSAGE"]!)
            }else{
                result(FlutterError(code: "FAILED", message: "Unable to send message", details: nil))
            }
        case "joinGroup":
            let args = call.arguments as! [String: String]
            if args.count == 1{
                self.joinGroup(result: result, groupID: args["GUID"]!)
            }else{
                result(FlutterError(code: "FAILED", message: "Unable to join the group", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    //initialize the CometChat SDK
    func isCometChatInitialized(result: @escaping FlutterResult){
        CometChat(appId: APP_ID, onSuccess: { (isSuccess) in
            result(Bool(isSuccess))
        }) { (error) in
            // Initialization failed with exception: error.ErrorDescription
            result(FlutterError(code: "FAILED",
                                message: "CometChat failed to initialize", details: nil))
        }
    }
    
    
    //login user to CometChat
    func loginUser(result: @escaping FlutterResult, uid: String, apiKey: String){
        CometChat.login(UID: uid, apiKey: apiKey, onSuccess: { (user) in
            // Login Successful
            let data: [String: Any] = ["RESULT":true,
                                       "AVATAR":user.avatar ?? "null",
                                       "CREDITS": user.credits,
                                       "EMAIL": user.email ?? "null",
                                       "LAST_ACTIVE":String(user.lastActiveAt),
                                       "NAME":user.name ?? "null",
                                       "ROLE":user.role ?? "null",
                                       "STATUS":String(describing: user.status.rawValue),
                                       "STATUS_MESSAGE":user.statusMessage ?? "null"]
            let jsonData =  try? JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted])
            result(String(data: jsonData!, encoding: .ascii))
        }) { (error) in
            // Login error
            result(FlutterError(code: "FAILED", message:"Login failed with exception: " + error.errorDescription, details: nil))
            
        }
    }
    
    //send message to a CometChat user
    func sendMessage(result: @escaping FlutterResult, receiverID: String, text: String){
        let textMessage = TextMessage(receiverUid: receiverID, text: text, messageType: .text, receiverType: .group)
        CometChat.sendTextMessage(message: textMessage, onSuccess: { (message) in
            result(Bool(true))
        }) { (error) in
            // error
            result(FlutterError(code: "FAILED", message: error!.errorDescription, details: nil))
        }
    }
    
    func joinGroup(result: @escaping FlutterResult, groupID: String){
        let guid = groupID;
        
        CometChat.joinGroup(GUID: guid, groupType: .public, password: nil, onSuccess: { (group) in
    
            // Success
            print("Group joined successfully: " + group.stringValue())
            result(Bool(true))
            
        }) { (error) in
            
            // Failure
            print("Group joining failed with exception:" + error!.errorDescription);
        }
    }
    
    //receive message
    func onTextMessageReceived(textMessage: TextMessage?, error : CometChatException?) {
        guard let eventSink = eventSink else {
            return
        }
        if error != nil{
            eventSink(FlutterError(code: "FAILED", message: error!.errorDescription, details: nil))
        }else{
            print("Message received successfully: " + textMessage!.text)
            let data: [String: Any] = ["Message":textMessage?.text ?? "null", "SenderUID":textMessage?.sender?.uid ?? "null"]
            let jsonData =  try? JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted])
            eventSink(String(data: jsonData!, encoding: .ascii))
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
