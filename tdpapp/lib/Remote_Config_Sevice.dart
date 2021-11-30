// import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class RemoteConfigService {
//   final StreamController<dynamic> _fetchingError = StreamController<dynamic>.broadcast();
//   Stream<dynamic> get fetchingErrorStream => _fetchingError.stream;
//   StreamController<dynamic> get fetchingErrorController =>
//       StreamController<dynamic>.broadcast();

//   Future<RemoteConfig> setupRemoteConfig() async {
//     await Firebase.initializeApp();
//     final RemoteConfig remoteConfig = RemoteConfig.instance as RemoteConfig;
//     await remoteConfig.setConfigSettings(RemoteConfigSettings(
//       fetchTimeout: const Duration(seconds: 200),
//       minimumFetchInterval: const Duration(minutes: 30),
//     ));
//     await remoteConfig.setDefaults(<String, dynamic>{
//       'showModal': false,
//       'LoginScreen': {
//         'Login': 'Demo',
//         'showAdd': false,
//       }
//     });
//   }
// }
