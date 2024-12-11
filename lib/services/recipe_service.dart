import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:belajar_flutter/models/recipe_model.dart';
import 'package:belajar_flutter/services/session_service.dart';

const String baseUrl = "https://recipe.incube.id/api";

class RecipeService {
  final SessionService _sessionService = SessionService();
  Future<List<RecipeModel>> getAllRecipe() async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      print("Tidak ada token");
    }

    final response = await http.get(Uri.parse('$baseUrl/recipes'), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data']['data'];
      return data.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal load data');
    }
  }

  Future<RecipeModel> getRecipeById(int id) async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      print("Tidak ada token");
    }

    final response = await http.get(Uri.parse('$baseUrl/recipes/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return RecipeModel.fromJson(data);
    } else {
      throw Exception('Gagal load data');
    }
  }

  Future<bool> createRecipe({
    required String title,
    required String description,
    required String cookingMethod,
    required String ingredients,
    required String photoPath,
  }) async {
    final token = await _sessionService.getToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/recipes'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['cooking_method'] = cookingMethod;
    request.fields['ingredients'] = ingredients;
    request.files.add(await http.MultipartFile.fromPath('photo', photoPath));

    final response = await request.send();

    return response.statusCode == 201;
  }
}
