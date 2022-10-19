// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:dart/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

Future<void> login(Store<AppState> store, dynamic action,
    NextDispatcher nextDispatcher) async {
  if (action is LoginUser) {
    try {
      await http
          .post(Uri.parse('http://localhost:3000/api/auth/login'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'username': action.username,
                'password': action.password,
              }))
          .then((value) async => {
                if (jsonDecode(value.body)['message'] != null)
                  {
                    store.dispatch(SetLoginErrorMessage(
                        loginErrorMessage:
                            jsonDecode(value.body)['message'].toString()))
                  },
                store
                    .dispatch(SetToken(token: jsonDecode(value.body)['token'])),
                const FlutterSecureStorage().write(key: 'token', value: jsonDecode(value.body)['token']),
                await http.get(Uri.parse('http://localhost:3000/api/auth/me'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'autorization':
                          'Bearer ${jsonDecode(value.body)['token']}'
                    }).then((value) => {
                      if (jsonDecode(value.body)['userId'] != null)
                        {
                          store.dispatch(
                              SetLoginErrorMessage(loginErrorMessage: '')),
                          store.dispatch(SetUser(
                              userId: jsonDecode(value.body)['userId'],
                              username: jsonDecode(value.body)['username'],
                              userImg: jsonDecode(value.body)['imgUrl'])),
                          Navigator.of(action.context).pushNamedAndRemoveUntil(
                              '/user', (route) => false)
                        }
                      else if (jsonDecode(value.body)['message'])
                        {
                          store.dispatch(SetLoginErrorMessage(
                              loginErrorMessage:
                                  jsonDecode(value.body)['message']))
                        }
                    })
              });
    } catch (e) {
      devtools.log('error trying to login');
    }
  }
  nextDispatcher(action);
}

void getMe(token, store, context) async {
  try {
    await http.get(Uri.parse('http://localhost:3000/api/auth/me'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'autorization': 'Bearer $token'
        }).then((value) => {
          store.dispatch(SetUser(
              userId: jsonDecode(value.body)['userId'],
              username: jsonDecode(value.body)['username'],
              userImg: jsonDecode(value.body)['imgUrl'])),
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/user', (route) => false)
        });
  } catch (e) {
    devtools.log('error trying to get current user');
  }
}

void createCategory(token, title, color, userId, store) async {
  try {
    await http
        .post(Uri.parse('http://localhost:3000/api/category/create'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'autorization': 'Bearer $token'
            },
            body: jsonEncode({
              'title': title,
              'color': color,
              'userId': userId,
            }))
        .then((value) async => {title = '', getUsersCategories(userId, store)});
  } catch (e) {
    devtools.log('error trying to create new category');
  }
}

void deleteCategory(token, categoryId, userId, store) async {
  try {
    await http.delete(
        Uri.parse('http://localhost:3000/api/category/$categoryId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'autorization': 'Bearer $token'
        }).then((value) {
      getUsersCategories(userId, store);
    });
  } catch (e) {
    devtools.log('error trying to delete category');
  }
}

void deleteLink(linkId, categoryId, store) async {
  try {
    await http.delete(
        Uri.parse('http://localhost:3000/api/link/$linkId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }).then((value) {
          getCategoriesLinks(categoryId, store);
    });
  } catch (e) {
    devtools.log('error trying to delete links');
  }
}

void getUsersCategories(userId, store) async {
  try {
    await http.get(Uri.parse('http://localhost:3000/api/category/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }).then((value) {
      store.dispatch(SetCategories(categories: jsonDecode(value.body)));
    });
  } catch (e) {
    devtools.log('error trying to get users category');
  }
}

void getOpenedCategory(categoryId, store) async {
  try {
    await http.get(
        Uri.parse('http://localhost:3000/api/category/$categoryId/links'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }).then((value) => {
          store.dispatch(
              SetOpenedCategory(openedCategory: jsonDecode(value.body)))
        });
  } catch (e) {
    devtools.log('error trying to get current opened category');
  }
}

void getCategoriesLinks(categoryId, store) async {
  try {
    await http
        .post(
          Uri.parse('http://localhost:3000/api/link/getAllCategoriesLinks'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'categoryId': categoryId,
          }),
        )
        .then((value) =>
            {store.dispatch(SetLinks(links: jsonDecode(value.body)['links']))});
  } catch (e) {
    devtools.log('error trying to get categories links');
  }
}

void getLinkData(value, store, title, description) async {
  try {
    await http
        .post(
          Uri.parse('http://localhost:3000/api/link/getLinkData'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'postData': value,
          }),
        )
        .then((data) => {
              if (jsonDecode(data.body)['linkData'].isNotEmpty)
                {
                  store.dispatch(
                      SetLinkData(linkData: jsonDecode(data.body)['linkData'])),
                  title.text = store.state.linkData['title'] ?? '',
                  description.text = store.state.linkData['description'] ?? ''
                }
              else
                {devtools.log(jsonDecode(data.body)['message'].toString())}
            });
  } catch (e) {
    devtools.log('error trying to get categories links');
  }
}

void createLink(categoryId, store, title, description, url, image, authorId,
    context) async {
  try {
    await http
        .post(
          Uri.parse('http://localhost:3000/api/link/create'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'title': title,
            'description': description ?? '',
            'url': url,
            'image': image ?? '',
            'author': authorId,
            'category': categoryId,
          }),
        )
        .then((value) => {
              getCategoriesLinks(categoryId, store),
              Navigator.pop(context),
              store.dispatch(SetLinkData(linkData: {}))
            });
  } catch (e) {
    devtools.log('error trying to create new link');
  }
}

void createUser(image, username, password, store, context) async {
  try {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://localhost:3000/api/auth/register'));
    request.fields['username'] = username;
    request.fields['password'] = password;
    if (image != null) {
      File file = File(image.path);
      var multiport = http.MultipartFile(
          'file', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.toString());
      request.files.add(multiport);
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      final result = jsonDecode(responseData.body) as Map<String, dynamic>;
      store.dispatch(SetRegistrationErrorMessage(
          errorMessage: result['message'].toString()));
      if (result['token'] != null) {
        var token = result['token'];
        getMe(token, store, context);
      }
    } else {
      devtools.log('server error');
    }
  } catch (e) {
    devtools.log('general error during creating user');
  }
}
