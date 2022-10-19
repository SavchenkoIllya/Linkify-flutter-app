// ignore_for_file: implementation_imports, unnecessary_import, no_leading_underscores_for_local_identifiers, deprecated_member_use

import 'package:dart/redux/middelwares.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dart/global_variables.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dart/redux/store.dart';
import 'dart:developer' as devtools show log;

import '../redux/app_state.dart';

class LinkPage extends StatelessWidget {
  const LinkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalColors _colors = GlobalColors();

    return Scaffold(
      backgroundColor: _colors.gray,
      appBar: AppBar(
          backgroundColor: _colors.gray,
          elevation: 0,
          leading: BackButton(
            color: _colors.blackText,
          ),
          actions: [
            IconButton(
              onPressed: (() {
                Navigator.pushNamed(context, '/newLink');
              }),
              icon: Icon(
                CupertinoIcons.add_circled,
                size: 30,
                color: _colors.blackText,
              ),
            )
          ],
          title: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, vm) => Text(
                    vm.openedCategory['title'] ?? '...loading',
                    style: TextStyle(
                        fontSize: 18,
                        color: _colors.blackText,
                        fontWeight: FontWeight.w700),
                  ))),
      body: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, vm) => vm.links.isNotEmpty
            ? ListView.builder(
                itemCount: vm.links.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () async {
                        final url = (vm.links[index]['url']);
                        if (await canLaunchUrl(Uri.parse(url))) {
                          try {
                            await launch(url, forceSafariVC: true);
                          } catch (e) {
                            devtools.log(e.toString());
                          }
                        }
                      },
                      child: Dismissible(
                        key: ValueKey(vm.links[index]['_id']),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          deleteLink(vm.links[index]['_id'],
                              vm.currentCategoryId, store);
                        },
                        child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: _colors.cardShadow,
                                      blurRadius: 16,
                                      offset: const Offset(0, 0))
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${vm.links[index]['title']}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: _colors.blackText,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${vm.links[index]['description']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _colors.grayText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                    child: vm.links[index]['image'] != ''
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                "${vm.links[index]['image']}",
                                            placeholder: (context, url) =>
                                                const SizedBox(
                                              width: 60,
                                              height: 60,
                                              child:
                                                  CupertinoActivityIndicator(),
                                            ),
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )
                                        : const SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: CupertinoActivityIndicator(),
                                          ))
                              ],
                            )),
                      ),
                    ),
                  );
                })
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'You don\'t have any categories yet! Create now!',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
