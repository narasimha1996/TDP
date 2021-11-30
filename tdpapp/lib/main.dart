import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tdpapp/HomePage.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'TDP'),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/Home': (context) => HomePage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  TextEditingController phnoInputController = TextEditingController();
  TextEditingController emailInputController = new TextEditingController();
  TextEditingController pwdInputController = TextEditingController();
  bool loader = false;
  String _homeScreenText = "Waiting for token...";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  _firebaseMessaging.subscribeToTopic('TopicToListen');
    // _firebaseMessaging.subscribeToTopic("foobar");
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
    FirebaseInAppMessaging.instance.triggerEvent("");
    // FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);
    // FirebaseInAppMessaging.instance.setMessagesSuppressed(true);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Login',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.green),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextFormField(
                decoration: new InputDecoration(
                    hintText: "Mobile No",
                    labelText: 'Mobile No',
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
                style: new TextStyle(fontSize: 16),
                keyboardType: TextInputType.phone,
                controller: phnoInputController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextFormField(
                decoration: new InputDecoration(
                    hintText: "Password",
                    labelText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
                style: new TextStyle(fontSize: 16),
                keyboardType: TextInputType.text,
                controller: pwdInputController,
              ),
            ),
            loader
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RaisedButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {
                        loader = true;
                      });
                      funjfd();
                    },
                    color: Colors.blue,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ]),
        ))));
  }

  funjfd() async {
    var res = await Firestore.instance
        .collection('User')
        .where('phoneNo', isEqualTo: phnoInputController.text)
        .where('password', isEqualTo: pwdInputController.text)
        .getDocuments();
    if (res.documents.length > 0) {
      setState(() {
        loader = false;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage(ress: res)));

      print(res.documents.length);
    }
    print(res);
  }
}
