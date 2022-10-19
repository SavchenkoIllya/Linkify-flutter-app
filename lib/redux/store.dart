// ignore_for_file: unused_import, depend_on_referenced_packages

import 'package:dart/redux/app_state.dart';
import 'package:dart/redux/middelwares.dart';
import 'package:dart/redux/reducers.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

final store = Store(reducer,
    middleware: [
      login
    ],
    initialState: AppState(
        token: '',
        currentUser: {},
        usersCategories: [],
        currentCategoryId: '',
        openedCategory: {},
        links: [],
        linkData: {},
        registrationErrorMessage: '',
        loginErrorMessage: '',)
        );
