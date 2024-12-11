import 'package:belajar_flutter/ui/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:belajar_flutter/models/recipe_model.dart';
import 'package:belajar_flutter/services/recipe_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  late Future<List<RecipeModel>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = _recipeService.getAllRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-recipe');
        },
        child: Icon(Icons.add),
        tooltip: "Tambah Item", // Tooltip saat tombol ditekan lama
      ),
      body: FutureBuilder<List<RecipeModel>>(
          future: futureRecipes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error load data ${snapshot.error}"),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text("Tidak ada data"),
              );
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];
                  return CustomCard(
                      id: data.id,
                      title: data.title,
                      img: data.photoUrl,
                      likes_count: data.likesCount,
                      comments_count: data.commentsCount);
                },
              );
            }
          }),
    );
  }
}

// ignore: must_be_immutable
class CustomCard extends StatelessWidget {
  String title;
  String img;
  int likes_count;
  int comments_count;
  int id;
  CustomCard({
    required this.id,
    required this.title,
    required this.img,
    required this.likes_count,
    required this.comments_count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailScreen(id: id);
            },
          ),
        );
      },
      child: SizedBox(
        height: 200,
        child: Card(
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                img,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 80,
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 1),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        Text("$likes_count")
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.comment,
                          color: Colors.blueGrey,
                        ),
                        Text("$comments_count")
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
