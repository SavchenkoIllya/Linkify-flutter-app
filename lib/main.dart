// ignore_for_file: depend_on_referenced_packages
import 'package:dart/pages/user.dart';
import 'package:dart/redux/store.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:dart/pages/registration.dart';
import 'package:dart/pages/login.dart';
import 'package:dart/pages/link.dart';
import 'package:dart/pages/new_link.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/': (context) => const LoginPage(),
            '/registration': (context) => const RegistrationPage(),
            '/user': (context) => const UserPage(),
            '/link': (context) => const LinkPage(),
            '/newLink': (context) => const NewLink(), 
          },
        ));
  }
}
