import 'dart:convert';
import 'dart:typed_data';
import 'package:get_storage/get_storage.dart';
import '../model/user_model.dart';

class DbHelper {
  static const JsonDecoder _decoder = JsonDecoder();
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  static const String _userModel = "userModel";
  static const String _isLoggedIn = "isLoggedIn";
  static const String _isVerified = "isVerified";
  static const String _token = "token";
  static const String is_mobile_login = "is_mobile_login";
  static const String _email = "email";
  static const String _phone = "phone";
  static const String _fullname = "fullname";
  static const String _id = "id";
  static const String _selectedCategory = "selectedCategory";
  static const String _finalselectedCategory = "finalselectedCategory";
  static const String _selectedCategoryName = "selectedCategoryName";
  static const String _saveIndex = "saveIndex";
  static const String _selectedCategoryId = "selectedCategoryId";
  static const String _category = "category";
  static const String _skip = "skip";

  static GetStorage box = GetStorage();

  static writeData(String key, dynamic value) async {
    await box.write(key, value);
  }

  static readData(String key) {
    return box.read(key);
  }

  static deleteData(String key) async {
    await box.remove(key);
  }

  static eraseData() async {
    await box.erase();
  }

  static bool getIsLoggedIn() {
    return readData(_isLoggedIn) ?? false;
  }

  static void saveIsLoggedIn(bool value) {
    writeData(_isLoggedIn, value);
  }

  static bool getIsVerified() {
    return readData(_isVerified) ?? false;
  }

  static void saveIsVerified(bool value) {
    writeData(_isVerified, value);
  }

  static bool get_skip() {
    return readData(_skip) ?? false;
  }

  static void save_skip(bool value) {
    writeData(_skip, value);
  }

  static void saveUserModel(UserModel? model) {
    if (model != null) {
      String value = _encoder.convert(model);
      writeData(_userModel, value);
    } else {
      writeData(_userModel, null);
    }
  }

  static UserModel? getUserModel() {
    String? user = readData(_userModel);
    if (user != null) {
      Map<String, dynamic> userMap = _decoder.convert(user);
      return UserModel.fromJson(userMap);
    } else {
      return null;
    }
  }

  static void saveToken(String? token) {
    writeData(_token, token);
  }

  static void saveIsMobileLogin(String? is_mobile_login1) {
    writeData(is_mobile_login, is_mobile_login1);
  }
  static void saveCategory(String? category) {
    writeData(_category, category);
  }
  static void saveName(String? name) {
    writeData(_fullname, name);
  }
  static void saveId(String? id) {
    writeData(_id, id);
  }
  static void saveEmail(String? email) {
    writeData(_email, email);
  }
  static void savePhone(String? phone) {
    writeData(_phone, phone);
  }

  static String? getToken() {
    return readData(_token);
  }
  static String? getIsMobileLofin() {
    return readData(is_mobile_login);
  }

  static String? getCategory() {
    return readData(_category);
  }
  static String? getName() {
    return readData(_fullname);
  }
  static String? getId() {
    return readData(_id);
  }
  static String? getEmail() {
    return readData(_email);
  }
  static String? getPhone() {
    return readData(_phone);
  }

  static String imageToBase64String(Uint8List image) {
    return base64Encode(image);
  }

  static void saveSelectedCategory(String? value) {
    if (value?.isEmpty ?? false) {
      return;
    }
    writeData(_selectedCategory, value);
  }
  static void finalsaveSelectedCategory(String? value) {
    if (value?.isEmpty ?? false) {
      return;
    }
    writeData(_finalselectedCategory, value);
  }
  static void saveSelectedCategoryName(String? value) {
    if (value?.isEmpty ?? false) {
      return;
    }
    writeData(_selectedCategoryName, value);
  }
  static void saveIndex(String? value) {
    if (value?.isEmpty ?? false) {
      return;
    }
    writeData(_saveIndex, value);
  }

  static String getIndex() {
    return readData(_saveIndex) ?? '0';
  }
 static String getSelectedCategory() {
    return readData(_selectedCategory) ?? '612';
  }
  static String getfinalSelectedCategory() {
    return readData(_finalselectedCategory) ?? '612';
  }
 static String getSelectedCategoryName() {
    return readData(_selectedCategoryName) ?? '612';
  }

  static void saveSelectedCategoryId(String? value) {
    if (value?.isEmpty ?? false) {
      return;
    }
    writeData(_selectedCategoryId, value);
  }

  static String getSelectedCategoryId() {
    return readData(_selectedCategoryId) ?? '612';
  }


}
