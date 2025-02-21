// import 'package:base_x/base_x.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:elera/helpers/db_helper.dart';
import 'package:elera/model/category_list_model.dart';
import 'package:elera/model/dashboard_model.dart';
import 'package:elera/model/notification_model.dart';
import 'package:elera/network/api_constants.dart';
import 'package:elera/network/base_client.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:elera/routes/app_routes.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:go_router/go_router.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../base/base/base_view_model.dart';
import '../base/base_x.dart';
import '../base/network/api_request.dart';
import '../dialogs/delete_account_dialog.dart';
import '../dialogs/logout_dialog.dart';
import '../helpers/dialog_helper.dart';
import '../helpers/string_helper.dart';
import '../model/bookmark_model.dart';
import '../model/common/map_response.dart';
import '../model/user_model.dart';
import 'main_view_model.dart';

class HomeViewModel extends BaseViewModel {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isLoading = false;

  String catagoryName = "";
  bool isDialogShow=false;

  String _selectedCatValue = DbHelper.getSelectedCategory();
  String _selectedCatId = DbHelper.getSelectedCategoryId();
  String _selectedCatName = DbHelper.getSelectedCategoryName();

  String get selectedCatValue => _selectedCatValue;

  String get selectedCatId => _selectedCatId;

  String get selectedCatName => _selectedCatName;

  final _noScreenshot = NoScreenshot.instance;

  void enableScreenshot() async {
    bool result = await _noScreenshot.screenshotOn();
    debugPrint('Enable Screenshot: $result');
  }

  void disableScreenshot() async {
    bool result = await _noScreenshot.screenshotOff();
    debugPrint('Screenshot Off: $result');
  }

  set selectedCatValue(String value) {
    DbHelper.saveSelectedCategory(value);
    _selectedCatValue = value;
    notifyListeners();
  }

  set selectedCatId(String value) {
    DbHelper.saveSelectedCategoryId(value);
    _selectedCatId = value;
    notifyListeners();
  }

  set selectedCatName(String value) {
    DbHelper.saveSelectedCategoryName(value);
    _selectedCatName = value;
    notifyListeners();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  void selectCategory({required String? catagory_id}) async {
    DialogHelper.showLoading();
    Map<String, dynamic> body = {
      'category_id': catagory_id,
    };

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.updateProfileUrl,
        requestType: RequestType.POST,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel> model = MapResponse<UserModel>.fromJson(
        response, (json) => UserModel.fromJson(json));

    DbHelper.saveUserModel(model.body);
    DbHelper.saveSelectedCategory(model.body?.category?.subcategories?[0].slug);
    DbHelper.saveSelectedCategoryId("${model.body?.categoryId}");
    DialogHelper.hideLoading();
    if (context.mounted) context.go(AppRouter.home);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    FirebaseAnalytics.instance.logEvent(name: 'increment_button_press');
    FirebaseAnalytics.instance.logEvent(
      name: 'screen_open',
      parameters: <String, Object>{
        'screen_name': 'home_screen',
      },
    );
    refreshController.dispose();
    refreshController = RefreshController(initialRefresh: false);
/*    FBroadcast.instance().register(StringHelper.go_to_course_detail,
            (value, callback) async {
          var section_id = value["section_id"]!;
          var course_id = value["course_id"]!;
          await getCourseListandCourse(sectionId: section_id,course_id:course_id);
        });*/
    // fetchCourseListandCourse();
  }

  /* Future<DashboardData?> getCourseListandCourse(
      {required String sectionId}) async {
    String categoryId = DbHelper.getSelectedCategoryId();
    ApiRequest apiRequest = ApiRequest(
      url:
      "${ApiConstants.courseListUrl}?category_id=$categoryId&section_id=$sectionId",
      requestType: RequestType.GET,
    );

    var response = await BaseClient.handleRequest(apiRequest);

    DashboardModel model = DashboardModel.fromJson(response);

    // Example: if you want to return specific data from model.data
    return model.data;
  }*/

  /* Future<void> fetchCourseListandCourse(*/ /*RemoteMessage message*/ /*) async {
    try {
      // Replace with your sectionId and course_id parameters
    */ /*  String sectionId = message.data["section_id"];
      String courseId = message.data["course_id"]; */ /*

      String sectionId = "9";
      String courseId = "2076";

      // Call your method to fetch data
      DashboardData? data = await getCourseListandCourse(sectionId: sectionId);

      // Handle data as needed
      if (data != null) {
        for(int i=0;i<data!.courselistfree!.length;i++){
          if(data.courselistfree![i].id.toString()==courseId){
            print("course detail"+data.courselistfree![i].toString());
            context.go(
                AppRouter.courseDetail,
                extra: {
                  'item': data.courselistfree![i],
                  'type': data.courselistfree![i].type
                });
            break;
          }
        }
        for(int i=0;i<data!.courselistpaid!.length;i++){
          if(data.courselistpaid![i].id==courseId){
            context.go(
                AppRouter.coursepaidDetail,
                extra: {
                  'item': data.courselistpaid![i],
                  'type': data.courselistpaid![i].type
                });
          }
        }
      } else {

        // Handle case where data is null
        print('No data received');
      }
    } catch (e) {
      // Handle errors
      print('Error fetching course list and course: $e');
    }
  }*/

  Future<DashboardData?> getCourseListandCourse(
      {required String sectionId,
      required String catagoryId,
      required String courseId}) async {
    String categoryId = DbHelper.getSelectedCategoryId();
    ApiRequest apiRequest = ApiRequest(
        url:
            "${ApiConstants.courseListUrl}?category_id=$categoryId&section_id=$sectionId",
        requestType: RequestType.GET);

    var response = await BaseClient.handleRequest(apiRequest);

    DashboardModel model = DashboardModel.fromJson(response);

    if (model.data != null) {
      DashboardData data = model!.data!;
      DialogHelper.showToast(message: courseId);
      for (int i = 0; i < data!.courselistfree!.length; i++) {
        if (data!.courselistfree![i].id.toString() == courseId.toString()) {
          context.push(AppRouter.courseDetail, extra: {
            'item': data!.courselistfree![i],
            'type': data!.courselistfree![i].type
          });
        }
      }

      for (int i = 0; i < data!.courselistpaid!.length; i++) {
        print("course id" + courseId.toString());
        if (data!.courselistpaid![i].id.toString() == courseId) {
          context.push(AppRouter.courseDetail, extra: {
            'item': data!.courselistpaid![i],
            'type': data!.courselistpaid![i].type
          });
        }
      }
    } else {
      // Handle case where data is null
      print('No data receiveddsssf');
    }

    // context.push(AppRouter.courseListSection, extra: model.data?.courselistfree);

    return model.data;
  }

/*  void getCourseListandCourse(
      {required String sectionId,
      required String catagoryId,
      required String courseId}) async {

    // String categoryId = DbHelper.getSelectedCategoryId();
    ApiRequest apiRequest = ApiRequest(
      url:
          "${ApiConstants.courseListUrl}?category_id=$catagoryId&section_id=$sectionId",
      requestType: RequestType.GET,
    );

    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<DashboardModel> model = MapResponse<DashboardModel>.fromJson(
        response, (json) => DashboardModel.fromJson(json));

    // Handle data as needed
    if (model.body != null && model.body!.data != null) {
      DashboardData data = model.body!.data!;
      DialogHelper.showToast(message: courseId);
      for (int i = 0; i < data!.courselistfree!.length; i++) {
        if (data!.courselistfree![i].id.toString() == courseId.toString()) {
          context.push(AppRouter.courseDetail, extra: {
            'item': data!.courselistfree![i],
            'type': data!.courselistfree![i].type
          });
        }
      }

      for (int i = 0; i < data!.courselistpaid!.length; i++) {
        print("course id" + courseId.toString());
        if (data!.courselistpaid![i].id.toString() == courseId) {
          context.push(AppRouter.courseDetail, extra: {
            'item': data!.courselistpaid![i],
            'type': data!.courselistpaid![i].type
          });
        }
      }
    } else {
      // Handle case where data is null
      print('No data receiveddsssf');
    }

    // Example: if you want to return specific data from model.data
  }*/

  Future<DashboardData?> dashboardApiCall() async {
    /*  if(selectedCatId==null) {
      selectedCatId = "612";
    }*/
    isLoading = true;
    // notifyListeners();
    ApiRequest apiRequest = ApiRequest(
        url: "${ApiConstants.dashoradUrl}?category_id=$selectedCatId",
        requestType: RequestType.GET);
    var response = await BaseClient.handleRequest(apiRequest);
    print(response);

    DashboardModel model = DashboardModel.fromJson(response);
    if (model.statusCode == 200) {
      isLoading = false;
      if (catagoryName == "") {
        catagoryName = model.data!.category_name.toString();
        notifyListeners();
      }
      print("sadasdas");
      DbHelper.saveId(model.data?.user_id.toString());
      refreshController.refreshCompleted();
      if (model.data?.screenrecordpermissions?.permission == "Yes") {
        enableScreenshot();
        // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      } else {
        disableScreenshot();
        // await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      }
      return model.data;
    } else {
      throw model;
    }

    // isLoading = false;
  }

  Future<List<CategoryListData>> getCategoryListApiCall() async {
    isLoading = true;
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.categoryListUrl, requestType: RequestType.GET);
    var response = await BaseClient.handleRequest(apiRequest);

    CategoryListModel model = CategoryListModel.fromJson(response);

    if (model.statusCode == 200) {
      isLoading = false;
      return model.data ?? [];
    } else {
      throw model;
    }
  }

  Future<Data> getNotification() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getnotification, requestType: RequestType.GET);
    var response = await BaseClient.handleRequest(apiRequest);

    Notifications model = Notifications.fromJson(response);

    if (model.statusCode == 200) {
      return model.data;
    } else {
      throw model;
    }
  }

  void deletenotification({required String data}) async {
    DialogHelper.showLoading();
    Map<String, dynamic> body = {
      'id': data,
    };

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.deletenotification,
        requestType: RequestType.POST,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel> model = MapResponse<UserModel>.fromJson(
        response, (json) => UserModel.fromJson(json));

    DialogHelper.hideLoading();
    // notifyListeners();
  }

  void selectCategory1({required CategoryListData data}) async {
    DialogHelper.showLoading();
    Map<String, dynamic> body = {
      'category_id': data.id,
    };

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.updateProfileUrl,
        requestType: RequestType.POST,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel> model = MapResponse<UserModel>.fromJson(
        response, (json) => UserModel.fromJson(json));

    DbHelper.saveUserModel(model.body);
    DbHelper.saveSelectedCategory(model.body?.category?.slug);
    DbHelper.saveSelectedCategoryId("${model.body?.categoryId}");
    DialogHelper.hideLoading();
    DbHelper.saveIndex("0");
    final viewModel = Provider.of<MainViewModel>(context, listen: false);
    viewModel.currentIndex = 0; // Set the index to 0
    context.push(AppRouter.home);

    // notifyListeners();
  }

  /*Future<bool> onWillPop(BuildContext context) async {
    *//*  if (_currentIndex != 0) {
      _currentIndex = 0;
     context.push(AppRouter.home);
      notifyListeners();
      return Future.value(false);
    } else {*//*
    isDialogShow=true;
    bool exitConfirmed = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(StringHelper.exit_app),
              content: Text(StringHelper.sure_exit_app),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    isDialogShow=false;
                    Navigator.of(context).pop(false); // User pressed No
                  },
                  child: Text(StringHelper.no),
                ),
                TextButton(
                  onPressed: () {
                    isDialogShow=false;
                    Navigator.of(context).pop(true); // User pressed Yes
                  },
                  child: Text(StringHelper.yes),
                ),
              ],
            );
          },
        ) ??
        true;

    if (exitConfirmed) {
      SystemNavigator.pop();
    }
    return Future.value(false);
    *//*   }*//*
  }*/


  Future<bool> onWillPop(BuildContext context) async {
    if (!isDialogShow) {
      isDialogShow = true;

      // Show exit confirmation dialog
      bool exitConfirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(StringHelper.exit_app),
            content: Text(StringHelper.sure_exit_app),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  isDialogShow = false;
                  Navigator.of(context).pop(false); // User pressed No
                },
                child: Text(StringHelper.no),
              ),
              TextButton(
                onPressed: () {
                  isDialogShow = false;
                  Navigator.of(context).pop(true); // User pressed Yes
                },
                child: Text(StringHelper.yes),
              ),
            ],
          );
        },
      ) ?? false;

      if (exitConfirmed) {
        SystemNavigator.pop(); // Exit the app
      }
    }

    // Prevent default back action when dialog is shown
    return Future.value(false);
  }

  Future<bool> gotohomeScreen(BuildContext context) async {
    /*  if (_currentIndex != 0) {
      _currentIndex = 0;
     context.push(AppRouter.home);
      notifyListeners();
      return Future.value(false);
    } else {*/
    bool exitConfirmed = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(StringHelper.exit_app),
              content: Text(StringHelper.sure_exit_app),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // User pressed No
                  },
                  child: Text(StringHelper.no),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // User pressed Yes
                  },
                  child: Text(StringHelper.yes),
                ),
              ],
            );
          },
        ) ??
        true;

    if (exitConfirmed) {
      SystemNavigator.pop();
    }
    return Future.value(false);
    /*   }*/
  }

  void showLogOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LogoutDialog();
      },
    );
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DeleteAccountDialog();
      },
    );
  }
}
