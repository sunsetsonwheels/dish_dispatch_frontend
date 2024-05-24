import 'dart:convert';

import 'package:dish_dispatch/models/customers.dart';
import 'package:dish_dispatch/models/orders.dart';
import 'package:dish_dispatch/models/restaurant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpBodyType {
  static const String json = "application/json; charset=utf-8";
  static const String multipartForm = "multipart/form-data";
  static const String plainText = "text/plain; charset=utf-8";
}

class APIRequestError implements Exception {
  int? code;
  String? detail;

  APIRequestError(this.code, this.detail);

  @override
  String toString() {
    return "ApiRequestError: $detail ($code)";
  }
}

class APIProvider extends ChangeNotifier {
  late final SharedPreferences _prefs;
  final _secureStorage = const FlutterSecureStorage();
  final http.Client _client = http.Client();

  late String _apiRoot;

  Customer? customer;
  CustomerAuth? _customerAuth;
  bool get isLoggedIn => customer != null;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _apiRoot = _prefs.getString("apiRoot") ?? "localhost:8000";
    final customerPhone = await _secureStorage.read(key: "phone");
    final customerPassword = await _secureStorage.read(key: "password");
    if (customerPhone != null && customerPassword != null) {
      _customerAuth = CustomerAuth(
        phone: customerPhone,
        password: customerPassword,
      );
    }
    await getCustomer();
  }

  // MARK: Core

  Future<String> _sendRequest(
    String endpoint, {
    Map<String, String> queryParams = const {},
    String method = "GET",
    dynamic body,
    String? contentType = HttpBodyType.json,
    bool authRequired = false,
  }) async {
    Uri fullUri = Uri.http(_apiRoot, endpoint, queryParams);
    late http.BaseRequest request;
    if (contentType == HttpBodyType.multipartForm) {
      http.MultipartRequest req = http.MultipartRequest(method, fullUri);
      request = req;
    } else {
      http.Request req = http.Request(method, fullUri);
      if (body != null) {
        switch (contentType) {
          case HttpBodyType.json:
            req.body = jsonEncode(body);
            break;
          case HttpBodyType.plainText:
            req.body = body as String;
        }
      }
      request = req;
    }
    if (contentType != null) {
      request.headers['Content-Type'] = contentType;
    }
    if (authRequired) {
      if (_customerAuth == null) {
        throw APIRequestError(401, "Not logged in!");
      }
      request.headers['Authorization'] = _customerAuth!.toString();
    }
    http.Response response =
        await http.Response.fromStream(await _client.send(request));
    if (response.statusCode >= 299) {
      throw APIRequestError(response.statusCode, response.body);
    }
    return response.body;
  }

  // MARK: Customers
  Future<void> saveCustomerAuth({
    required String phone,
    required String password,
  }) async {
    await _secureStorage.write(key: "phone", value: phone);
    await _secureStorage.write(key: "password", value: password);
    _customerAuth = CustomerAuth(phone: phone, password: password);
    notifyListeners();
  }

  Future<void> getCustomer() async {
    if (_customerAuth == null) throw APIRequestError(401, "Not logged in!");
    customer = Customer.fromJson(
        jsonDecode(await _sendRequest("/customers/info", authRequired: true)));
    notifyListeners();
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'phone');
    await _secureStorage.delete(key: 'password');
    _customerAuth = null;
    notifyListeners();
  }

  Future<void> changeCustomerPhone(String phone) async {
    await _sendRequest(
      "/customers/info/phone",
      method: "PATCH",
      body: phone,
      contentType: HttpBodyType.plainText,
      authRequired: true,
    );
    customer?.phone = phone;
    notifyListeners();
  }

  Future<void> changeCustomerName(String name) async {
    await _sendRequest(
      "/customers/info/name",
      method: "PATCH",
      body: name,
      contentType: HttpBodyType.plainText,
      authRequired: true,
    );
    customer?.name = name;
    notifyListeners();
  }

  Future<void> changeCustomerAddress(String address) async {
    await _sendRequest(
      "/customers/info/address",
      method: "PATCH",
      body: address,
      contentType: HttpBodyType.plainText,
      authRequired: true,
    );
    customer?.address = address;
    notifyListeners();
  }

  Future<void> changeCustomerCreditCard({
    required String number,
    required String code,
    required String expiry,
  }) async {
    CustomerCreditCard cc = CustomerCreditCard(
      number: number,
      code: code,
      expiry: expiry,
    );
    await _sendRequest(
      "/customers/info/credit_card",
      method: "PATCH",
      body: cc.toJson(),
      contentType: HttpBodyType.json,
      authRequired: true,
    );
    customer?.creditCard = cc;
    notifyListeners();
  }

  Future<void> setCustomerMembership({
    required CustomerMembershipPlan? plan,
  }) async {
    if (plan != null) {
      final CustomerMembership membership = CustomerMembership(
        plan: plan,
        startDate: DateTime.now(),
      );
      await _sendRequest(
        "/customers/info/membership",
        method: "POST",
        body: membership.toJson(),
        authRequired: true,
      );
      customer?.membership = membership;
    } else {
      await _sendRequest(
        "/customers/info/membership",
        method: "DELETE",
        authRequired: true,
      );
      customer?.membership = null;
    }
    notifyListeners();
  }

  Future<void> submitCustomerOrder({required Order order}) async {
    await _sendRequest(
      "/customers/orders",
      method: "POST",
      body: order.toJson(),
      authRequired: true,
    );
  }

  Future<List<Order>> getCustomerOrders() async {
    try {
      final orders = jsonDecode(await _sendRequest(
        "/customers/orders",
        authRequired: true,
      )) as List<dynamic>;
      return orders
          .map<Order>((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (err) {
      print(err.toString());
      return [];
    }
  }

  Future<Order> getCustomerOrder({required String id}) async {
    return Order.fromJson(jsonDecode(
        await _sendRequest("/customers/orders/$id", authRequired: true)));
  }

  // MARK: Restaurants
  Future<RestaurantResponse> getRestaurants({
    String? cuisine,
    String? name,
  }) async {
    Map<String, String> queryParams = {};
    if (cuisine != null) {
      queryParams['cuisine'] = cuisine;
    }
    if (name != null) {
      queryParams['name'] = name;
    }
    return RestaurantResponse.fromJson(jsonDecode(await _sendRequest(
      "/restaurants/",
      queryParams: queryParams,
    )));
  }

  Future<Restaurant> getRestaurantDetails({required String id}) async {
    return Restaurant.fromJson(
        jsonDecode(await _sendRequest("/restaurants/$id")));
  }

  String getRestaurantImageUri({
    required String restaurant,
    required String filename,
  }) {
    return Uri.encodeFull("http://$_apiRoot/static/imgs/$restaurant/$filename");
  }
}
