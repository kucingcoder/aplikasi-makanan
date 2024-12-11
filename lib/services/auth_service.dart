import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:belajar_flutter/models/response_model.dart';
import 'package:belajar_flutter/services/session_service.dart';

const String baseUrl = "https://recipe.incube.id/api";

class AuthService {
  final SessionService _sessionService = SessionService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Successful login usually returns 200
        ResponseModel res = ResponseModel.fromJson(jsonDecode(response.body));
        print(res.data['token']);
        await _sessionService.saveToken(res.data['token']);
        await _sessionService.saveUser(
          res.data['user']['id'].toString(),
          res.data['user']['name'],
          res.data['user']['email'],
        );
        return {"status": true, "message": res.massage};
      } else if (response.statusCode == 401) {
        ResponseModel res = ResponseModel.fromJson(jsonDecode(response.body));
        return {
          "status": false,
          "message": res.massage,
        };
      } else {
        return {
          "status": false,
          "message": "Login failed. Please try again.",
        };
      }
    } catch (e) {
      return {
        "status": false,
        "message": "An error occurred: ${e.toString()}",
      };
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        // Successful registration usually returns 201
        ResponseModel res = ResponseModel.fromJson(jsonDecode(response.body));
        await _sessionService.saveToken(res.data['token']);
        await _sessionService.saveUser(
          res.data['user']['id'].toString(),
          res.data['user']['name'],
          res.data['user']['email'],
        );
        return {"status": true, "message": res.massage};
      } else if (response.statusCode == 422) {
        ResponseModel res = ResponseModel.fromJson(jsonDecode(response.body));
        Map<String, dynamic> err = res.error as Map<String, dynamic>;
        return {"status": false, "message": res.massage, "errors": err};
      } else {
        return {
          "status": false,
          "message": "Registration failed. Please try again.",
        };
      }
    } catch (e) {
      return {
        "status": false,
        "message": "An error occurred: ${e.toString()}",
      };
    }
  }
}
