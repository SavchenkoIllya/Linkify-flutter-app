import 'package:flutter/material.dart';

class SetToken {
  final String token;

  SetToken({required this.token});
}

class LoginUser {
  final String username;
  final String password;
  final BuildContext context;

  LoginUser(
      {required this.username, required this.password, required this.context});
}

class GetMeAction {
  final String token;

  GetMeAction({required this.token});
}

class SetUser {
  final String username;
  final String userId;
  final String userImg;

  SetUser(
      {required this.username, required this.userId, required this.userImg});
}

class GetUsersCategoryAction {
  final String userId;

  GetUsersCategoryAction({required this.userId});
}

class SetCategories {
  final List categories;

  SetCategories({required this.categories});
}

class CreateCatgory {
  final String title;
  final String userId;
  final String color;
  final String token;

  CreateCatgory(
      {required this.title,
      required this.color,
      required this.userId,
      required this.token});
}

class SetCategoryId {
  final String categoryId;

  SetCategoryId({required this.categoryId});
}

class SetOpenedCategory {
  final Map openedCategory;

  SetOpenedCategory({required this.openedCategory});
}

class SetLinks {
  final List links;

  SetLinks({required this.links});
}

class SetLinkData{
  final Map linkData;

  SetLinkData({required this.linkData});
}

class SetRegistrationErrorMessage{
  final String errorMessage;

  SetRegistrationErrorMessage({required this.errorMessage});
}

class SetLoginErrorMessage{
  final String loginErrorMessage;

  SetLoginErrorMessage({required this.loginErrorMessage});
}