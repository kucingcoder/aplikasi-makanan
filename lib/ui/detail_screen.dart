import 'package:belajar_flutter/models/recipe_model.dart';
import 'package:belajar_flutter/services/recipe_service.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int id = widget.id;
  final RecipeService _recipeService = RecipeService();
  late RecipeModel Recipes;
  int likes = 0, comments = 0;
  String img = 'https://via.placeholder.com/150',
      title = '',
      description = '',
      ingredients = '',
      step = '';

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  fetchdata() async {
    Recipes = await _recipeService.getRecipeById(id);
    setState(() {
      likes = Recipes.likesCount;
      comments = Recipes.commentsCount;
      img = Recipes.photoUrl;
      title = Recipes.title;
      description = Recipes.description;
      ingredients = Recipes.ingredients;
      step = Recipes.cookingMethod;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              img,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow),
                          Text('$likes likes')
                        ],
                      ),
                      SizedBox(width: 24),
                      Row(
                        children: [
                          const Icon(
                            Icons.comment,
                            color: Colors.blueGrey,
                          ),
                          Text('$comments comments')
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Description',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(description),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ingredients',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(ingredients),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Steps',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(step),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
