import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mooreview/dataProvider/datas/loginResponse.dart';
import 'package:http/http.dart' as http;
import 'package:mooreview/dataProvider/datas/reviewData.dart';

import 'datas/movieData.dart';

class DataProvider {
  // Create data provider singleton
  DataProvider._privateCons();

  static final DataProvider _i = DataProvider._privateCons();
  static final FlutterSecureStorage storage = FlutterSecureStorage();
  static String _token = "";
  static String _refresh = "";

  factory DataProvider() {
    return _i;
  }

  static const String baseUrl = 'https://moo-api.lightbear.net';

  void setTokenInClass(String token, String refresh) {
    _token = token;
    _refresh = refresh;
  }

  Future<bool> login(String email, String password) async {
    var payload = {'Email': email, 'Password': password};
    var res = await http.post(baseUrl + '/api/login', body: payload);
    if (res.statusCode == 200) {
      await setToken(LoginResponse.fromJson(jsonDecode(res.body)));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(
      String email, String password, String firstName, String lastName) async {
    var payload = {
      "email": email,
      "password": password,
      "firstName": firstName,
      "lastName": lastName
    };
    var res = await http.post(baseUrl + '/api/register', body: payload);
    if (res.statusCode == 200) {
      await setToken(LoginResponse.fromJson(jsonDecode(res.body)));
      return true;
    } else {
      return false;
    }
  }

  Future<List<MovieData>> getAllMovie() async {
    var res = await http.get(baseUrl + "/api/movies",
        headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'});
    if (res.statusCode == 200) {
      List<MovieData> result = [];
      var data = jsonDecode(res.body) as List;
      for (var value in data) {
        result.add(MovieData.fromJson(value));
      }
      return result;
    } else if (res.statusCode == 401 && res.body == "Invalid or expired JWT") {
      //refresh jwt
    }
    return null;
  }

  Future<List<ReviewData>> getMovieReviews(String id) async {
    var res = await http.get(
      baseUrl + '/api/review/$id',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'},
    );
    if (res.statusCode == 200) {
      List<ReviewData> result = [];
      var data = jsonDecode(res.body) as List;
      for (var value in data) {
        result.add(ReviewData.fromJson(value));
      }
      return result;
    } else if (res.statusCode == 401 && res.body == "Invalid or expired JWT") {
      //refresh jwt
    }
    return null;
  }

  Future<bool> addNewMovie(String name) async {
    var res = await http.post(baseUrl + '/api/movie/add',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'},
        body: {"name": name});
    if (res.statusCode == 200) {
      return true;
    } else if (res.statusCode == 401 && res.body == "Invalid or expired JWT") {
      // Refresh token

    }
    return false;
  }

  Future<bool> addNewReview(String comment, int rating, String id) async {
    var res = await http.post(baseUrl + '/api/review/$id/add',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'},
        body: {"Rating": rating.toString(), "Comment": comment});
    if (res.statusCode == 200) {
      return true;
    } else if (res.statusCode == 401 && res.body == "Invalid or expired JWT") {
      // Refresh token

    }
    return false;
  }

  Future setToken(LoginResponse data) async {
    await storage.write(key: "token", value: data.token);
    await storage.write(key: "refresh", value: data.refresh);
    setTokenInClass(data.token, data.refresh);
  }

  Future logout() async {
    await storage.deleteAll();
  }
}
