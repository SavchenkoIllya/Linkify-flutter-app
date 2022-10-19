class AppState {
  String token = '';
  Map<String, String> currentUser = {};
  List usersCategories = [];
  String currentCategoryId = '';
  Map openedCategory = {};
  List links = [];
  Map linkData = {};
  String registrationErrorMessage = '';
  String loginErrorMessage = '';

  AppState(
      {required this.currentUser,
      required this.token,
      required this.usersCategories,
      required this.currentCategoryId,
      required this.openedCategory,
      required this.links,
      required this.linkData,
      required this.registrationErrorMessage,
      required this.loginErrorMessage});
}
