// ignore_for_file: unused_element, depend_on_referenced_packages, unused_import
import 'package:dart/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'actions.dart';
import 'dart:developer' as devtools show log;

AppState reducer(AppState state, dynamic action) => AppState(
      token: _tokenReducer(state.token, action),
      currentUser: _userReducer(state.currentUser, action),
      usersCategories: _categoryReducer(state.usersCategories, action),
      currentCategoryId: _categoryIdReducer(state.currentCategoryId, action),
      openedCategory: _openedCategoryReducer(state.openedCategory, action),
      links: _setLinksReducer(state.links, action),
      linkData: _setLinkDataReducer(state.linkData, action),
      registrationErrorMessage: _setRegistrationErrorMessageReducer(
          state.registrationErrorMessage, action),
      loginErrorMessage:
          _setLoginErrorMessageReducer(state.loginErrorMessage, action),
    );

Reducer<Map> _setLinkDataReducer =
    combineReducers([TypedReducer<Map, SetLinkData>(_setLinkData)]);

Reducer<List> _setLinksReducer =
    combineReducers([TypedReducer<List, SetLinks>(_setLinks)]);

Reducer<String> _tokenReducer =
    combineReducers([TypedReducer<String, SetToken>(_setTokenReducer)]);

Reducer<Map<String, String>> _userReducer = combineReducers(
    [TypedReducer<Map<String, String>, SetUser>(_setUserReducer)]);

Reducer<List> _categoryReducer =
    combineReducers([TypedReducer<List, SetCategories>(_setCategoryReducer)]);

Reducer<String> _categoryIdReducer = combineReducers(
    [TypedReducer<String, SetCategoryId>(_setCategoryIdReducer)]);

Reducer<Map> _openedCategoryReducer =
    combineReducers([TypedReducer<Map, SetOpenedCategory>(_setOpenedCategory)]);

Reducer<String> _setRegistrationErrorMessageReducer = combineReducers([
  TypedReducer<String, SetRegistrationErrorMessage>(
      _setRegistrationErrorMessage)
]);

Reducer<String> _setLoginErrorMessageReducer = combineReducers(
    [TypedReducer<String, SetLoginErrorMessage>(_setLoginErrorMessage)]);

String _setTokenReducer(String token, SetToken action) => action.token;

Map<String, String> _setUserReducer(
        Map<String, String> currentUser, SetUser action) =>
    {
      'username': action.username,
      'userId': action.userId,
      'userImg': action.userImg
    };

List _setCategoryReducer(List usersCategories, SetCategories action) =>
    action.categories;

String _setCategoryIdReducer(String categoryId, SetCategoryId action) =>
    action.categoryId;

Map _setOpenedCategory(Map openedCategory, SetOpenedCategory action) =>
    action.openedCategory;

List _setLinks(List links, SetLinks action) => action.links;

Map _setLinkData(Map linkData, SetLinkData action) => action.linkData;

String _setRegistrationErrorMessage(
        String errorMessage, SetRegistrationErrorMessage action) =>
    action.errorMessage;

String _setLoginErrorMessage(
        String loginErrorMessage, SetLoginErrorMessage action) =>
    action.loginErrorMessage;
