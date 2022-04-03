import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:tikodo_app/models/login_response_model.dart';

/// A service that provides shared methods.
class SharedService {
  /// A method that check if login details are stored in the cache.
  static Future<bool> isLoggedIn() async {
    var isKeyExist =
        await APICacheManager().isAPICacheKeyExist("login_details");

    return isKeyExist;
  }

  /// A method that get login details from cache.
  static Future<LoginResponseModel?> loginDetails() async {
    var isKeyExist =
        await APICacheManager().isAPICacheKeyExist("login_details");

    if (isKeyExist) {
      var cacheData = await APICacheManager().getCacheData("login_details");

      return loginResponseJson(cacheData.syncData);
    }
    return null;
  }

  /// A method that stores login details in the cache.
  static Future<void> setLoginDetails(
    LoginResponseModel model,
  ) async {
    APICacheDBModel cacheDBModel = APICacheDBModel(
        key: "login_details", syncData: jsonEncode(model.toJson()));
    await APICacheManager().addCacheData(cacheDBModel);
  }

  /// A method that removes login details from the cache and sends the user
  /// to the login screen.
  static Future<void> logout(BuildContext context) async {
    final navigator = Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
    await APICacheManager().deleteCache("login_details");
    navigator;
  }
}
