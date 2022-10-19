// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, unused_import

import 'package:dart/global_variables.dart';
import 'package:dart/redux/actions.dart';
import 'package:dart/redux/app_state.dart';
import 'package:dart/redux/middelwares.dart';
import 'package:dart/redux/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart/extension.dart';
import 'package:dart/storage.dart';
import 'dart:developer' as devtools show log;

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final GlobalColors _colors = GlobalColors();
  bool openedCreator = false;
  Color pickerColor = Color.fromRGBO(0, 122, 255, 1);
  late final TextEditingController _title;

  @override
  void initState() {
    _title = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    getUsersCategories(store.state.currentUser['userId'], store);

    return Scaffold(
      backgroundColor: _colors.gray,
      appBar: AppBar(
          backgroundColor: _colors.gray,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (context, vm) => ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: vm.currentUser['userImg'] != ''
                      ? CachedNetworkImage(
                          imageUrl:
                              "http://127.0.0.1:8887/${vm.currentUser['userImg']}",
                          placeholder: (context, url) => Image.asset(
                            'assets/images/DefaultAvatar.png',
                          ),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : Image.asset(
                          'assets/images/DefaultAvatar.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 70),
              StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (context, vm) => Text(
                        vm.currentUser['username'].toString(),
                        style: TextStyle(color: _colors.blackText),
                      )),
              const SizedBox(width: 50),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                icon: Icon(
                  Icons.logout,
                  color: _colors.blackText,
                  size: 30.0,
                ),
              )
            ],
          )),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => {
                  setState(() {
                    openedCreator = !openedCreator;
                  })
                },
                style: ElevatedButton.styleFrom(
                    primary: !openedCreator ? _colors.blue : Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !openedCreator
                        ? const Icon(Icons.add)
                        : const Icon(Icons.close),
                    const SizedBox(
                      width: 20,
                    ),
                    !openedCreator
                        ? const Text('Add category')
                        : const Text('Abort')
                  ],
                ),
              ),
              openedCreator
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: TextField(
                            controller: _title,
                            decoration: InputDecoration(
                              hintText: 'Name your category',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                        Text(
                          'Try to avoid light colors because title is always white',
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        HueRingPicker(
                          pickerColor: pickerColor,
                          onColorChanged: changeColor,
                          enableAlpha: false,
                          displayThumbColor: false,
                        ),
                        ElevatedButton(
                          onPressed: () => {
                            createCategory(
                                store.state.token,
                                _title.text,
                                pickerColor.toHex().toString(),
                                store.state.currentUser['userId'],
                                store),
                            setState(() {
                              openedCreator = !openedCreator;
                            })
                          },
                          style: ElevatedButton.styleFrom(
                              primary: _colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          child: const Text('Add category'),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (context, vm) => !openedCreator
                      ? SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: vm.usersCategories.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: ValueKey(vm.usersCategories[index]['_id']),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: Text(
                                            "Are you shure that you want to delete?"),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            onPressed: () {
                                              deleteCategory(
                                                  store.state.token,
                                                  vm.usersCategories[index]
                                                      ['_id'],
                                                  store.state
                                                      .currentUser['userId'],
                                                  store);
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Text(
                                              "Yes",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          CupertinoDialogAction(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: Text("No"),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: GestureDetector(
                                  onTap: (() {
                                    store.dispatch(SetCategoryId(
                                        categoryId: vm.usersCategories[index]
                                            ['_id']));
                                    getOpenedCategory(
                                        store.state.currentCategoryId, store);
                                    getCategoriesLinks(
                                        store.state.currentCategoryId, store);
                                    Navigator.pushNamed(context, '/link');
                                  }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _colors.cardBackground,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _colors.cardShadow,
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          height: double.infinity,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    bottomLeft:
                                                        Radius.circular(15)),
                                                color: vm.usersCategories[index]
                                                        ['color']
                                                    .toString()
                                                    .toColor()),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${vm.usersCategories[index]['title']}',
                                            textAlign: TextAlign.left,
                                            softWrap: true,
                                            maxLines: 3,
                                            style: TextStyle(
                                                color: _colors.blackText,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Container()),
              StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (context, vm) =>
                      store.state.usersCategories.isEmpty && !openedCreator
                          ? Container(
                              padding: EdgeInsets.only(top: 50),
                              alignment: Alignment.center,
                              child: Text(
                                'You don\'t have any categories yet. Create first!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: _colors.blackText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))
                          : Container())
            ],
          ),
        ),
      ),
    );
  }
}
