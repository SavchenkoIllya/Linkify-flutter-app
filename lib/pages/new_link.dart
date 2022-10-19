import 'package:dart/redux/actions.dart';
import 'package:dart/redux/middelwares.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dart/redux/store.dart';
import 'package:dart/global_variables.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer' as devtools show log;

import '../redux/app_state.dart';

class NewLink extends StatefulWidget {
  const NewLink({Key? key}) : super(key: key);

  @override
  State<NewLink> createState() => _NewLinkState();
}

class _NewLinkState extends State<NewLink> {
  final GlobalColors _colors = GlobalColors();
  late final TextEditingController _link;
  late final TextEditingController _title;
  late final TextEditingController _description;

  @override
  void initState() {
    _link = TextEditingController();
    _title = TextEditingController();
    _description = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _link.dispose();
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
              onPressed: (() => {
                    store.dispatch(SetLinkData(linkData: {})),
                    Navigator.pop(context)
                  })),
          elevation: 0,
          backgroundColor: _colors.green,
          title: const Text(
            'New Link',
          )),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const Text(
            'Past your link here',
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            onChanged: (value) {
              if (Uri.parse(value).host.isNotEmpty) {
                getLinkData(value, store, _title, _description);
              } else {
                devtools.log('false');
              }
            },
            controller: _link,
            decoration: const InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              hintText: 'https://yourwebsite.com',
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Title',
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Description',
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: _description,
            decoration: const InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, vm) => vm.linkData.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: "${vm.linkData['images'][0]}",
                      placeholder: (context, url) => const CupertinoActivityIndicator(),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : Container()),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () => {
              createLink(
                  store.state.currentCategoryId,
                  store,
                  _title.text,
                  _description.text,
                  store.state.linkData['url'],
                  store.state.linkData['images'][0] ?? '',
                  store.state.currentUser['userId'],
                  context)
            },
            style: ElevatedButton.styleFrom(
                primary: _colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
            child: const Text('Create link'),
          )
        ]),
      ),
    );
  }
}
