import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tikodo_app/configuration.dart';
import 'package:tikodo_app/models/login_request_model.dart';
import 'package:tikodo_app/models/login_response_model.dart';
import 'package:tikodo_app/models/register_request_model.dart';
import 'package:tikodo_app/models/register_response_model.dart';
import 'package:tikodo_app/models/todo_model.dart';
import 'package:tikodo_app/services/shared_service.dart';

class APIService {
  static var client = http.Client();

  static Future<String> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.parse(Config.apiURL + Config.loginAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(loginResponseJson(response.body));
      return "";
    } else {
      return response.reasonPhrase.toString();
    }
  }

  static Future<dynamic> register(RegisterRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.parse(Config.apiURL + Config.registerAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode.toString() != "201") {
      return registerResponseModel(
          '{"email": "${response.reasonPhrase.toString()}", "first_name":"", "last_name":"" }');
    }

    return registerResponseModel(response.body);
  }

  static Future<List<Todo>> getTodos() async {
    if (await verifyToken() == false) {
      refreshToken();
    }

    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.access}'
    };

    var url = Uri.parse(Config.apiURL + Config.todosAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final List t = json.decode(response.body);
      final List<Todo> todoList = t.map((item) => Todo.fromJson(item)).toList();
      return todoList;
    } else {
      return <Todo>[];
    }
  }

  static Future<String> addTodo(String description) async {
    if (await verifyToken() == false) {
      refreshToken();
    }

    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.access}'
    };

    var url = Uri.parse(Config.apiURL + Config.todosAPI);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(<String, String>{
        'description': description,
      }),
    );

    if (response.statusCode.toString() == "400") {
      return response.body.toString();
    }
    return "Todo successfully created!";
  }

  static Future<String> updateTodo(Todo todo) async {
    if (await verifyToken() == false) {
      refreshToken();
    }

    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.access}'
    };

    var url = Uri.parse('${Config.apiURL}${Config.todosAPI}${todo.id}');
    var response = await client.put(url,
        headers: requestHeaders,
        body: jsonEncode(<String, dynamic>{
          'description': todo.description,
          'done': !todo.done,
        }));
    if (response.statusCode.toString() == "400") {
      return "Todo not updated:/";
    }

    return "Todo updated successfully";
  }

  static Future<String> deleteTodo(int identifier) async {
    if (await verifyToken() == false) {
      refreshToken();
    }

    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.access}'
    };

    var url = Uri.parse('${Config.apiURL}${Config.todosAPI}$identifier');
    var response = await client.delete(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode.toString() == "400") {
      return "Todo not deleted :/";
    }
    return "Todo deleted successfully";
  }

  static Future<bool> verifyToken() async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      return false;
    }
    final refreshToken = loginDetails.refresh;
    var url = Uri.parse(Config.apiURL + Config.todosAPI);
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(<String, String>{
        'refresh': refreshToken,
      }),
    );

    if (response.statusCode == 401) {
      return false;
    }
    return true;
  }

  static Future<void> refreshToken() async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      SharedService.isLoggedIn();
    }
    final refreshToken = loginDetails!.refresh;
    var url = Uri.parse(Config.apiURL + Config.tokenRefreshAPI);
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(<String, dynamic>{
        "refresh": refreshToken.toString(),
      }),
    );

    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(loginResponseJson(response.body));
    } else {
      if (kDebugMode) {
        print(response.statusCode.toString());
      }
    }
  }
}
