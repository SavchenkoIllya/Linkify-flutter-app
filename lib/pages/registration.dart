import 'dart:io';
import 'package:dart/redux/middelwares.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dart/global_variables.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:dart/redux/store.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unused_import
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as devtools show log;
import '../redux/actions.dart';
import '../redux/app_state.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController _username;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  final GlobalColors _colors = GlobalColors();
  String correctUsername = '';
  String correctPassword = '';
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      devtools.log(e.toString());
    }
  }

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.gray,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 140),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 10,
            shadowColor: _colors.cardShadow,
            color: _colors.cardBackground,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                Text(
                  'Create new Account',
                  style: TextStyle(color: _colors.grayText),
                ),
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
                    onChanged: (value) {
                      if (value.length < 6) {
                        store.dispatch(SetRegistrationErrorMessage(
                            errorMessage:
                                'Username must be at least 6 characters'));
                      } else {
                        correctUsername = value;
                        store.dispatch(
                            SetRegistrationErrorMessage(errorMessage: ''));
                      }
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                    ],
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
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                    ],
                    onChanged: (value) {
                      if (value.length < 6) {
                        store.dispatch(SetRegistrationErrorMessage(
                            errorMessage: 'password is too short'));
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        store.dispatch(SetRegistrationErrorMessage(
                            errorMessage:
                                'Password must contain capital letter'));
                      } else {
                        store.dispatch(
                            SetRegistrationErrorMessage(errorMessage: ''));
                      }
                    },
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Repeat Password')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                    ],
                    onChanged: (value) {
                      if (value != _password.text) {
                        store.dispatch(SetRegistrationErrorMessage(
                            errorMessage: 'Passwords do not match'));
                      } else {
                        correctPassword = value;
                        store.dispatch(
                            SetRegistrationErrorMessage(errorMessage: ''));
                      }
                    },
                    controller: _confirmPassword,
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => {pickImage()},
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(width: 1, color: _colors.blue),
                              primary: _colors.gray,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              )),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.photo_camera,
                                color: _colors.blackText,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Upload photo',
                                style: TextStyle(color: _colors.blackText),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  image!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                StoreConnector<AppState, AppState>(
                    converter: (store) => store.state,
                    builder: (context, vm) =>
                        vm.registrationErrorMessage.isNotEmpty
                            ? Text(
                                vm.registrationErrorMessage,
                                style: const TextStyle(color: Colors.red),
                              )
                            : const Text('')),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () => {
                      if(correctUsername.isNotEmpty && correctPassword.isNotEmpty) {
                        createUser(image, correctUsername, correctPassword, store, context)
                      } else {
                        store.dispatch(SetRegistrationErrorMessage(errorMessage: 'Check your username and password'))
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: _colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    child: const Text('Registrate'),
                  ),
                ),
                TextButton(
                    onPressed: () => {
                          store.dispatch(
                              SetRegistrationErrorMessage(errorMessage: '')),
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/', (route) => false)
                        },
                    child: const Text('Already have account? Sign in'))
              ],
            ),
          )),
    );
  }
}
