import 'dart:convert';

import 'package:dish_dispatch/models/restaurant.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpBodyType {
  static const String json = "application/json";
  static const String multipartForm = "multipart/form-data";
}

class APIProvider extends ChangeNotifier {
  late final SharedPreferences _prefs;
  final http.Client _client = http.Client();
  final String _apiRoot = "http://localhost:8000";
  String? username;
  bool get isLoggedIn => username != null;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // MARK: Core

  Future<String> _sendRequest(
    String endpoint, {
    String method = "GET",
    dynamic body,
    String? contentType = HttpBodyType.json,
  }) async {
    Uri fullUri = Uri.parse("$_apiRoot$endpoint");
    late http.BaseRequest request;
    if (contentType == HttpBodyType.multipartForm) {
      // TODO: Handle multipart form
    } else {
      http.Request req = http.Request(method, fullUri);
      request = req;
    }
    http.Response response =
        await http.Response.fromStream(await _client.send(request));
    return response.body;
  }

  // MARK: Restaurants
  Future<Map<String, Restaurant>> getRestaurants({
    String? cuisine,
  }) async {
    return (jsonDecode(await _sendRequest("/restaurants/"))
            as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, Restaurant.fromJson(value)));
  }

  Future<RestaurantDetails> getRestaurantDetails({required String id}) async {
    return RestaurantDetails.fromJson(
        jsonDecode(await _sendRequest("/restaurants/$id")));
  }

  String getRestaurantImageUri({
    required String restaurant,
    required String filename,
  }) {
    return "$_apiRoot/static/imgs/$restaurant/$filename";
  }
}
