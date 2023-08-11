import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/firebase_options.dart';
import 'package:chat_me/provider/chat_provider.dart';
import 'package:chat_me/services/firebase_auth.dart';
import 'package:chat_me/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/contact_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    Provider<AuthService>(
      create: (_) => AuthService(),
    ),
    ChangeNotifierProvider(create: (_) => ContactProvider()),
    ChangeNotifierProvider(create: (_) => ChatProvider()),
  ], child: const MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'ChatMe',
      theme: ThemeData(
        fontFamily: josefinRegular,
        primarySwatch: Colors.blue,
      ),
      home: const Wrapper(),
    );
  }
}
