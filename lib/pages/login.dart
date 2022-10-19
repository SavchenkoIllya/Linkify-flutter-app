// ignore_for_file: , depend_on_referenced_packages, unused_import

import 'package:dart/global_variables.dart';
import 'package:dart/redux/actions.dart';
import 'package:dart/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:developer' as devtools show log;

import '../redux/middelwares.dart';
import '../redux/store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _username;
  late final TextEditingController _password;
  final GlobalColors _colors = GlobalColors();

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const FlutterSecureStorage().read(key: 'token').then((value) => {
          if (value != null)
            {
              store.dispatch(SetToken(token: value)),
              getMe(value, store, context),
            }
        });

    return Scaffold(
      backgroundColor: _colors.green,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 140),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 10,
            shadowColor: _colors.shadow,
            color: const Color.fromRGBO(242, 242, 247, 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/Linkify_logo.png',
                    height: 80, scale: 1),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Glad to meet you in Linkify app',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Text('Login please'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Username')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _username,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Username',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Password')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                StoreConnector<AppState, AppState>(
                    converter: (store) => store.state,
                    builder: (context, vm) => vm.loginErrorMessage.isNotEmpty
                        ? Text(
                            vm.loginErrorMessage,
                            style: const TextStyle(color: Colors.red),
                          )
                        : const Text('')),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () async => {
                      StoreProvider.of<AppState>(context).dispatch(LoginUser(
                          password: _password.text,
                          username: _username.text,
                          context: context))
                    },
                    style: ElevatedButton.styleFrom(
                        primary: _colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    child: const Text('Login'),
                  ),
                ),
                TextButton(
                    onPressed: () => {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/registration', (route) => false)
                        },
                    child: const Text('You are new here? Register now'))
              ],
            ),
          )),
    );
  }
}
